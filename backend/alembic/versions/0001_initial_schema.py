"""Esquema inicial de usuarios, fincas, animales y eventos

Revision ID: 0001_initial_schema
Revises:
Create Date: 2026-10-10 12:00:00.000000

"""
from typing import Sequence, Union
from alembic import op
import sqlalchemy as sa


revision: str = '0001_initial_schema'
down_revision: Union[str, None] = None
branch_labels: Union[str, Sequence[str], None] = None
depends_on: Union[str, Sequence[str], None] = None


def upgrade() -> None:
    op.create_table(
        'farms',
        sa.Column('id', sa.Integer(), nullable=False),
        sa.Column('nombre', sa.String(length=120), nullable=False),
        sa.Column('ubicacion', sa.String(length=240), nullable=True),
        sa.Column('created_at', sa.DateTime(timezone=True), server_default=sa.text('NOW()'), nullable=False),
        sa.PrimaryKeyConstraint('id')
    )
    op.create_index(op.f('ix_farms_nombre'), 'farms', ['nombre'], unique=False)

    op.create_table(
        'users',
        sa.Column('id', sa.Integer(), nullable=False),
        sa.Column('nombre', sa.String(length=120), nullable=False),
        sa.Column('email', sa.String(length=255), nullable=False),
        sa.Column('password_hash', sa.String(length=255), nullable=False),
        sa.Column('role', sa.String(length=30), server_default='ganadero', nullable=False),
        sa.Column('farm_id', sa.Integer(), nullable=True),
        sa.Column('created_at', sa.DateTime(timezone=True), server_default=sa.text('NOW()'), nullable=False),
        sa.ForeignKeyConstraint(['farm_id'], ['farms.id'], ondelete='SET NULL'),
        sa.PrimaryKeyConstraint('id')
    )
    op.create_index(op.f('ix_users_email'), 'users', ['email'], unique=True)

    op.create_table(
        'animals',
        sa.Column('id', sa.Integer(), nullable=False),
        sa.Column('farm_id', sa.Integer(), nullable=False),
        sa.Column('identificador', sa.String(length=80), nullable=False),
        sa.Column('nombre', sa.String(length=120), nullable=True),
        sa.Column('especie', sa.String(length=80), server_default='bovino', nullable=False),
        sa.Column('raza', sa.String(length=100), nullable=True),
        sa.Column('sexo', sa.String(length=20), nullable=True),
        sa.Column('fecha_nacimiento', sa.String(length=10), nullable=True),
        sa.Column('estado', sa.String(length=30), server_default='activo', nullable=False),
        sa.Column('created_at', sa.DateTime(timezone=True), server_default=sa.text('NOW()'), nullable=False),
        sa.ForeignKeyConstraint(['farm_id'], ['farms.id'], ondelete='CASCADE'),
        sa.PrimaryKeyConstraint('id'),
        sa.UniqueConstraint('farm_id', 'identificador', name='uq_animal_farm_identifier')
    )
    op.create_index(op.f('ix_animals_farm_id'), 'animals', ['farm_id'], unique=False)

    op.create_table(
        'animal_events',
        sa.Column('id', sa.Integer(), nullable=False),
        sa.Column('animal_id', sa.Integer(), nullable=False),
        sa.Column('tipo', sa.String(length=40), nullable=False),
        sa.Column('fecha', sa.String(length=10), nullable=False),
        sa.Column('responsable', sa.String(length=120), nullable=True),
        sa.Column('observaciones', sa.Text(), nullable=True),
        sa.Column('created_at', sa.DateTime(timezone=True), server_default=sa.text('NOW()'), nullable=False),
        sa.ForeignKeyConstraint(['animal_id'], ['animals.id'], ondelete='CASCADE'),
        sa.PrimaryKeyConstraint('id')
    )
    op.create_index(op.f('ix_animal_events_animal_id'), 'animal_events', ['animal_id'], unique=False)


def downgrade() -> None:
    op.drop_index(op.f('ix_animal_events_animal_id'), table_name='animal_events')
    op.drop_table('animal_events')
    op.drop_index(op.f('ix_animals_farm_id'), table_name='animals')
    op.drop_table('animals')
    op.drop_index(op.f('ix_users_email'), table_name='users')
    op.drop_table('users')
    op.drop_index(op.f('ix_farms_nombre'), table_name='farms')
    op.drop_table('farms')
