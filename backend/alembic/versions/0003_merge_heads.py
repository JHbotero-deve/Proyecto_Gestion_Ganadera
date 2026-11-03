"""Merge password recovery and performance index migrations.

Revision ID: 0003_merge_heads
Revises: 0002_password_recovery, 699e9c81b660
"""
from typing import Sequence, Union


revision: str = "0003_merge_heads"
down_revision: Union[str, Sequence[str], None] = ("0002_password_recovery", "699e9c81b660")
branch_labels: Union[str, Sequence[str], None] = None
depends_on: Union[str, Sequence[str], None] = None


def upgrade() -> None:
    pass


def downgrade() -> None:
    pass
