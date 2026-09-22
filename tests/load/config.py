from types import SimpleNamespace
from fixtures import TAOUserBank
from locust import  events, between

class TestingConfig:
    spawning_complete = False
    wait_time = None
    
    def __init__(self, user):
        self.host = user.host

        self.endpoints = SimpleNamespace(**dict(
            authServer=f'{self.host}/auth-server',
            portalBackend=f'{self.host}/portal-be',
            deliver=f'{self.host}/deliver'
        ))

testTakersBank = TAOUserBank(
        bank=range(1,100000),
        hydrator=lambda x: SimpleNamespace(**{
            'username': f'TT{x}',
            'password': 'ChangeMe',
            }),
        )

instructorsBank = TAOUserBank(
        bank=range(1,100000),
        hydrator=lambda x: SimpleNamespace(**{
            'username': f'IN{x}',
            'password': 'ChangeMe',
            }),
        )

profiles = [
    {"name": "Single (1u)", "users_count": 1},
    {"name": "Light (100u)", "users_count": 100},
    {"name": "Medium (500u)", "users_count": 500},
    {"name": "Heavy (1000u)", "users_count": 1000},
    {"name": "Raspberry Pi Light (20u)", "users_count": 20},
    {"name": "Raspberry Pi Medium (50u)", "users_count": 50},
    {"name": "Raspberry Pi Heavy (100u)", "users_count": 100},
]

wait_times = [
    {"name": "Slow (10-15s)", "wait": between(10.0, 15.0)},
    {"name": "Regular (1-5s)", "wait": between(1.0, 5.0)},
    {"name": "Fast (0.5-2s)", "wait": between(0.5, 2.0)},
    {"name": "Instant (0s)", "wait": lambda x: 0},
]