"""login social: contraseña opcional, proveedor y subject

Revision ID: a3f1c9d27b44
Revises: 699e9c81b660
Create Date: 2026-10-16

"""
from typing import Sequence, Union

from alembic import op
import sqlalchemy as sa


revision: str = "a3f1c9d27b44"
down_revision: Union[str, None] = "699e9c81b660"
branch_labels: Union[str, Sequence[str], None] = None
depends_on: Union[str, Sequence[str], None] = None


def upgrade() -> None:
    op.alter_column("users", "password_hash", existing_type=sa.String(length=255), nullable=True)
    op.add_column(
        "users",
        sa.Column("auth_provider", sa.String(length=20), server_default="local", nullable=False),
    )
    op.add_column("users", sa.Column("provider_subject", sa.String(length=255), nullable=True))
    op.create_unique_constraint("uq_user_provider_subject", "users", ["auth_provider", "provider_subject"])


def downgrade() -> None:
    # Falla si ya existen usuarios sociales sin contraseña: bórralos antes de revertir.
    op.drop_constraint("uq_user_provider_subject", "users", type_="unique")
    op.drop_column("users", "provider_subject")
    op.drop_column("users", "auth_provider")
    op.alter_column("users", "password_hash", existing_type=sa.String(length=255), nullable=False)