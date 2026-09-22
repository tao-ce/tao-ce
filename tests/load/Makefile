
VENV_PATH = ./.venv
TAO_CE_HOST = https://community.tao.internal

run:
	. $(VENV_PATH)/bin/activate && locust -H $(TAO_CE_HOST) --only-summary

install:
	python -m venv $(VENV_PATH)
	. $(VENV_PATH)/bin/activate && pip install -r requirements.txt



