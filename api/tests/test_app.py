import pandas as pd
from app.model import Criteria, TaxonomyInput
from app.taxonomy_method import calculate
from typing import List


class TestApp:
    def get_alternatives(self):
        alternatives = ["A1", "A2", "A3"]
        return alternatives

    def get_raw_matrix(self,reversed=False):
        data = {
            "C1": [0.71, 1.33, 1.45],
            "C2": [4.1, 5.9, 4.9],
            "C3": [0.18, 0.74, 0.27],
        }
        if(reversed):
            for k in data.keys():
                data[k].reverse()
        m_raw = pd.DataFrame(data)
        m_raw.index = self.get_alternatives()
        return m_raw

    def get_criterias(self):
        criterias = [
            Criteria(**{"name": "C1", "type": "cost"}),
            Criteria(**{"name": "C2", "type": "cost"}),
            Criteria(**{"name": "C3", "type": "benefit"}),
        ]
        return criterias

    def test_raw_matrix(self):
        results = calculate(
            self.get_raw_matrix(), self.get_alternatives(), self.get_criterias()
        )
        assert list(results.raw_matrix.keys()) == ["C1", "C2", "C3"]

    def test_ideal_values(self):
        results = calculate(
            self.get_raw_matrix(), self.get_alternatives(), self.get_criterias()
        )
        assert list(results.ideal_values.values()) == [
            -1.1414474258498064,
            -0.9609876522409447,
            1.141699209790852,
        ]

    def test_development_attributes(self):
        results = calculate(
            self.get_raw_matrix(reversed=True), self.get_alternatives(), self.get_criterias()
        )
        assert list(results.development_attributes.values()) == [
            0.5935529276115952,
            0.8076525191095986,
            0.8251133797284292,
        ]
