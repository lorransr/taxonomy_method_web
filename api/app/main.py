from fastapi import FastAPI
from fastapi.logger import logger 
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel,validator
from typing import List
from enum import Enum
import pandas as pd
import taxonomy_method
from model import TaxonomyInput,CriteriaType,TaxonomyOutput
import logging
from mangum import Mangum

logger = logging.getLogger()


app = FastAPI()

origins = ["*"]
app.add_middleware(
    CORSMiddleware,
    allow_origins=origins,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

@app.post("/taxonomy/")
def calculate_taxonomy_method(input:TaxonomyInput)->TaxonomyOutput:
    logger.info("received input")
    logger.info("input dict: {}".format(input.dict()))
    logger.info("pre processing")
    if input.alternatives_names == None:
        alternatives = [ "a_" + str(i) for i in range(1,len(input.alternatives)+1)]
    else:
        alternatives = input.alternatives_names
    m_raw = pd.DataFrame(input.alternatives,columns=[c.name for c in input.criterias])
    m_raw.index = alternatives
    logger.info(alternatives)
    logger.info("calculating taxonomy...")
    results = (
        taxonomy_method.calculate(
            m_raw,alternatives,input.criterias)
            )
    
    logger.info("sending results")
    logger.info("assessment_score: {}".format(results.dict()))
    return results.dict()

handler = Mangum(app)