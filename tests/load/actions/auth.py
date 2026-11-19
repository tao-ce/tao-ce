def login(task):
    with task.user.client.post(
        f"{task.user.config.endpoints.authServer}/v1/oauth2/tokens?with-refresh-token=true",
        name=task.name(f"{__name__}.login"),
        json={
            "grant_type": "password",
            "client_id": "portal-client-id-1",
            "username": task.user.username,
            "password": task.user.password,
        },
        catch_response=True,
    ) as response:
        task.user.push('access_token', response.json()['access_token'])
        task.user.push('refresh_token', response.json()['refresh_token'])
        response.success()

def refresh_tokens(task):
    with task.user.client.post(
        f'{task.user.config.endpoints.deliver}/api/v1/auth/refresh-tokens',
        name=task.name(f"{__name__}.refresh_tokens"),
        headers={}
            | task.user.headers.origin()
            | task.user.headers.json()
            | {
                'refresh-token': task.user.get('session_refresh_token'),
            }
        ,
        json={
            'deliveryExecutionId': task.user.get('execution_id'),
            'refreshTokenId': task.user.get('refresh_token_id'),
        },
        catch_response=True,
    ) as response:
        task.user.push('access_token', response.json()['accessToken'])
        task.user.push('session_refresh_token', response.json()['refreshTokenId'])
        response.success()
