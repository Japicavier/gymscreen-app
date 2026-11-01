"""
Application configuration, loaded once at startup.

ENV=local      -> values from backend/env.local
ENV=dev|prod   -> secrets from Azure Key Vault (KEY_VAULT_URL),
                  non-sensitive settings from Azure App Configuration
                  (APP_CONFIG_ENDPOINT, label = ENV)

Any missing value or failing service raises at import time, so the
container fails on startup instead of at request time.

Usage: from gymscreen.config import CONFIG; CONFIG["DB_HOST"]
"""

import os
from pathlib import Path
from types import MappingProxyType

from django.core.exceptions import ImproperlyConfigured

ENV = os.getenv("ENV", "local")
VALID_ENVS = ("local", "dev", "prod")

# Credentials -> Key Vault
SECRETS = [
    "DJANGO_SECRET_KEY",
    "DB_USER",
    "DB_PASSWORD",
]

# Non-sensitive settings -> App Configuration
SETTINGS = [
    "ALLOWED_HOSTS",
    "DB_NAME",
    "DB_HOST",
    "DB_PORT",
    "CORS_ALLOWED_ORIGINS",
]

ENV_FILE = Path(__file__).resolve().parent.parent.parent / "env.local"


def _load_local():
    from dotenv import dotenv_values

    if not ENV_FILE.exists():
        raise ImproperlyConfigured(f"ENV=local but {ENV_FILE} does not exist")
    return dotenv_values(ENV_FILE)


def _require_env(name):
    value = os.getenv(name)
    if not value:
        raise ImproperlyConfigured(f"ENV={ENV} requires the {name} environment variable")
    return value


def _load_azure():
    from azure.appconfiguration import AzureAppConfigurationClient
    from azure.core.exceptions import AzureError, ResourceNotFoundError
    from azure.identity import DefaultAzureCredential
    from azure.keyvault.secrets import SecretClient

    key_vault_url = _require_env("KEY_VAULT_URL")
    app_config_endpoint = _require_env("APP_CONFIG_ENDPOINT")
    credential = DefaultAzureCredential()
    values = {}

    # Key Vault 
    secret_client = SecretClient(vault_url=key_vault_url, credential=credential)
    for name in SECRETS:
        try:
            values[name] = secret_client.get_secret(name).value
        except ResourceNotFoundError:
            pass  # reported as missing below
        except AzureError as e:
            raise ImproperlyConfigured(f"Key Vault {key_vault_url} failed: {e}") from e

    app_config_client = AzureAppConfigurationClient(
        base_url=app_config_endpoint, credential=credential
    )
    try:
        for item in app_config_client.list_configuration_settings(label_filter=ENV):
            if item.key in SETTINGS:
                values[item.key] = item.value
    except AzureError as e:
        raise ImproperlyConfigured(
            f"App Configuration {app_config_endpoint} failed: {e}"
        ) from e

    return values


def _load():
    if ENV not in VALID_ENVS:
        raise ImproperlyConfigured(f"ENV must be one of {VALID_ENVS}, got {ENV!r}")

    values = _load_local() if ENV == "local" else _load_azure()

    missing = [name for name in SECRETS + SETTINGS if not values.get(name)]
    if missing:
        raise ImproperlyConfigured(
            f"Missing configuration for ENV={ENV}: {', '.join(missing)}"
        )
    return {name: values[name] for name in SECRETS + SETTINGS}


CONFIG = MappingProxyType(_load())
