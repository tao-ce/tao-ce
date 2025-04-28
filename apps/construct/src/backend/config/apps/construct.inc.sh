app_name="Backoffice"
app_tagline="TAO Backoffice (aka. Construct/Legacy), is authoring service for TAO CBT platform"
app_id=construct
app_fid="${proj_id}/${app_id}"
app_path=${proj_app_path}/construct

app_data_path=${proj_data_path}/construct

config_base_url=${CONSTRUCT_BASE_URL:-http://0.0.0.0/construct/}
config_tz=${CONSTRUCT_TZ:-UTC}
config_lang=${CONSTRUCT_LANG:-en-US}

app_install_sem=${app_data_path}/SEM_INSTALL_DONE
app_ready_sem=${app_data_path}/SEM_READY
