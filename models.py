from sqlalchemy import Column, Integer, String
from database import Base

# create table scans(id integer primary key autoincrement, domain varchar unique, path_to_res varchar, finished integer default 0);
class Scan(Base):
    __tablename__ = 'scans'
    id = Column(Integer, primary_key=True, autoincrement=True)
    domain = Column(String(100), unique=True)
    path_to_res = Column(String(200))
    finished = Column(Integer, default=0)

    def __init__(self, domain, path_to_res="", finished=0):
        self.path_to_res = path_to_res
        self.finished = finished
        self.domain = domain

    def __repr__(self):
        return '<Scan %r>' % (self.domain)
