## Benchmark


### Requirements

* Python >=3.14 with `pip`

### Setup

Install `locust` and related dependencies
```sh
make install
```

### Configure


in `config.py`, ensure to match `hydrator` to your user names and passwords
```python
testTakersBank = TAOUserBank(
        bank=range(1,100000),
        hydrator=lambda x: SimpleNamespace(**{
            'username': f'TT{x}',
            'password': 'ChangeMe',
            }),
        )
```

### Run

```
# Load local `venv`
. ./.venv/bin/activate

# Start locust (update -H option with your host)
locust -H https://community.tao.internal --only-summary
```

Then browse to [`http://0.0.0.0:8089`](`http://0.0.0.0:8089`)

### Benchmark

#### Ramp up methods

`linear`
: a uniform set of users is added every second to simulate a linear ramp up

`instant`
: all users are started in the same time

`normal`
: users are added following a normal distribution

`exponential`
: more and more users are added every second until target is reached 

Exemple for 100 users ramp up during 10s

|  time  | instant |   Δ   | linear |   Δ   | exponential |   Δ   | normal(0.2,0.05) |   Δ   | normal(0.3,0.1) |   Δ   | normal(0.4,0.15) |   Δ   | normal(0.5,0.2) |   Δ   |
| -----: | ------: | ----: | -----: | ----: | ----------: | ----: | ---------------: | ----: | --------------: | ----: | ---------------: | ----: | --------------: | ----: |
|      0 |     100 |  +100 |     10 |   +10 |           2 |    +2 |                1 |    +1 |               1 |    +1 |                1 |    +1 |               1 |    +1 |
|      1 |     100 |    +0 |     20 |   +10 |           3 |    +1 |                3 |    +2 |               3 |    +2 |                3 |    +2 |               3 |    +2 |
|      2 |     100 |    +0 |     30 |   +10 |           4 |    +1 |               50 |   +47 |              16 |   +13 |               10 |    +7 |               7 |    +4 |
|      3 |     100 |    +0 |     40 |   +10 |           7 |    +3 |               98 |   +48 |              50 |   +34 |               26 |   +16 |              16 |    +9 |
|      4 |     100 |    +0 |     50 |   +10 |          10 |    +3 |              100 |    +2 |              85 |   +35 |               50 |   +24 |              31 |   +15 |
|      5 |     100 |    +0 |     60 |   +10 |          16 |    +6 |              100 |    +0 |              98 |   +13 |               75 |   +25 |              50 |   +19 |
|      6 |     100 |    +0 |     70 |   +10 |          26 |   +10 |              100 |    +0 |             100 |    +2 |               91 |   +16 |              70 |   +20 |
|      7 |     100 |    +0 |     80 |   +10 |          40 |   +14 |              100 |    +0 |             100 |    +0 |               98 |    +7 |              85 |   +15 |
|      8 |     100 |    +0 |     90 |   +10 |          64 |   +24 |              100 |    +0 |             100 |    +0 |              100 |    +2 |              94 |    +9 |
|      9 |     100 |    +0 |    100 |   +10 |         100 |   +36 |              100 |    +0 |             100 |    +0 |              100 |    +0 |             100 |    +6 |


Exemple for 500 users ramp up during 120s

![Ramp up for 500 users during 120s](./docs/distributions-500-120.png)

#### Start benchmarks

* select a load profile (how many users)
* select a ramp up method (see before)
    - for `normal` method, you may need to change following parameters:
        * `mu_ratio`: mean ratio (default `0.5`). `0.2` means half of the users will be already started at 20% of ramp up time
        * `sigma`:  standard deviation (default `0.1`) `0.2` means 1σ (68.2%) of users will be started within 40% of timespan arround mean. e.g., for 500 users during 120s, it means 341 users will be started during 48s from t=24s to t=72s).
* set a ramp up duration (in seconds)
* select a wait time (how long user will wait between two API actions)
* click `START` to run benchmark