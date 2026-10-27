"""agrega indices de rendimiento

Revision ID: 699e9c81b660
Revises: 0001_initial_schema
Create Date: 2026-10-15

"""
from typing import Sequence, Union

from alembic import op
import sqlalchemy as sa


# revision identifiers, used by Alembic.
revision: str = "699e9c81b660"
down_revision: Union[str, None] = "0001_initial_schema"
branch_labels: Union[str, Sequence[str], None] = None
depends_on: Union[str, Sequence[str], None] = None


def upgrade() -> None:
    op.create_index("ix_animals_farm_estado", "animals", ["farm_id", "estado"])
    op.create_index("ix_animal_events_animal_fecha", "animal_events", ["animal_id", "fecha"])


def downgrade() -> None:
    op.drop_index("ix_animal_events_animal_fecha", table_name="animal_events")
    op.drop_index("ix_animals_farm_estado", table_name="animals")
