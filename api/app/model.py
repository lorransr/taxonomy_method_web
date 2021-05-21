from typing import List, Optional
from enum import Enum
from pydantic import BaseModel, validator


class CriteriaType(str, Enum):
    cost = "cost"
    benefit = "benefit"


class Criteria(BaseModel):
    name: str
    type: CriteriaType


class ShortestDistance(BaseModel):
    values: dict
    std: float
    mean: float


class TaxonomyOutput(BaseModel):
    raw_matrix: dict
    normalized_matrix: dict
    shortest_distance: ShortestDistance
    accepted_range: List[float]
    normalized_matrix_filtered: dict
    ideal_values: dict
    development_pattern: dict
    development_attributes: dict


class TaxonomyInput(BaseModel):
    criterias: List[Criteria]
    alternatives: List[List[float]]
    alternatives_names: Optional[List[str]]

    class Config:
        schema_extra = {
            "example": {
                "alternatives_names": ["ka", "onix", "prisma", "eco_esporte"],
                "criterias": [
                    {"name": "custo", "type": "cost"},
                    {"name": "mala", "type": "benefit"},
                    {"name": "seguranca", "type": "benefit"},
                    {"name": "conforto", "type": "benefit"},
                    {"name": "tempo_de_entrega", "type": "cost"},
                ],
                "alternatives": [
                    [40, 380, 11, 9, 22],
                    [52, 590, 13, 9, 10],
                    [68, 710, 15, 13, 25],
                    [92, 900, 18, 15, 2],
                ],
            }
        }

    @validator("alternatives")
    def alternatives_should_have_same_size(cls, v, values):
        sizes = []
        for a in v:
            sizes.append(len(a))
        print(len(set(sizes)))
        if len(set(sizes)) != 1:
            print("alternatives should have same size")
            raise ValueError("alternatives should have same size")
        elif "criterias" not in values:
            print("criterias should be provided")
            raise ValueError("criterias should be provided")
        elif sizes[0] != len(values["criterias"]):
            print("alternatives and criterias should have same length")
            raise ValueError("alternatives and criterias should have same length")
        else:
            return v

    @validator("alternatives_names")
    def alternatives_names_should_have_same_len_as_alternatives_vector(cls, v, values):
        if v == None:
            return v
        elif "alternatives" not in values:
            print("alternatives should be provided")
            raise ValueError("alternatives should be provided")
        elif len(v) != len(values["alternatives"]):
            raise ValueError(
                "alternatives len should have the same len of an alternative vector"
            )
        else:
            return v
