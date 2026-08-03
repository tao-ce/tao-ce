import utils.exception
from lxml import etree 

def get_lti_delivery_execution(task):
    with task.user.client.post(
        f"{task.user.config.endpoints.portalBackend}/api/v1/lti/launch-delivery-execution/{task.user.get('session_id')}",
        name=task.name(f"{__name__}.get_lti_delivery_execution"),
        headers={}
            | task.user.headers.authorization()
            | task.user.headers.json()
        ,
        json={
            'returnUrl': f"{task.user.config.endpoints.portalBackend}/my-sessions?sessionId={task.user.get('session_id')}"
        }
    ) as response:
        task.user.push('ltiLaunchLink', response.json()['ltiLaunchLink'])

def open_lti_delivery_execution(task):
    with task.user.client.get(
        task.user.get('ltiLaunchLink'),
        name=task.name(f"{__name__}.open_lti_delivery_execution"),
        catch_response=True,
    ) as response:
        if int(response.status) != 200:
            raise Exception(f'wrong status {response.status} {response.content}')
        doc = etree.XML(f"<root>{response.text}</root>")
        task.user.push('ltiActionUrl', doc.xpath('string(//root/form/@action)'))
        task.user.push('id_token', doc.xpath('string(//root/form/input[@name="id_token"]/@value)'))
        task.user.push('state', doc.xpath('string(//root/form/input[@name="state"]/@value)'))

def open_lti_action_delivery_execution(task):
    with task.user.client.post(
        task.user.get('ltiActionUrl'),
        name=task.name(f'{__name__}.open_lti_action_delivery_execution'),
        data={
            'id_token': task.user.get('id_token'),
            'state': task.user.get('state'),
        }
    ) as response:
        if int(response.status) != 200:
            raise Exception(f'wrong status {response.request.url} {response.status} {response.content}')
        doc = etree.XML(f"<root>{response.text}</root>")
        task.user.push('proctoringLtiActionUrl', doc.xpath('string(//root/form/@action)'))
        task.user.push('proctoringid_token', doc.xpath('string(//root/form/input[@name="id_token"]/@value)'))
        task.user.push('proctoringstate', doc.xpath('string(//root/form/input[@name="state"]/@value)'))

def open_lti_action_proctoring(task):
    with task.user.client.post(
        task.user.get('proctoringLtiActionUrl'),
        name=task.name(f'{__name__}.open_lti_action_proctoring'),
        data={
            'id_token': task.user.get('proctoringid_token'),
            'state': task.user.get('proctoringstate'),
        }
    ) as response:
        doc = etree.XML(f"<root>{response.text}</root>")
        task.user.push('deliverLtiActionUrl', doc.xpath('string(//root/form/@action)'))
        task.user.push('JWT', doc.xpath('string(//root/form/input[@name="JWT"]/@value)'))
        task.user.push('execution_id', task.user.get('deliverLtiActionUrl').split('/')[-1])

def open_lti_action_deliver(task):
    with task.user.client.post(
        task.user.get('deliverLtiActionUrl'),
        name=task.name(f'{__name__}.open_lti_action_deliver'),
        data={
            'JWT':  task.user.get('JWT'),
        }
    ) as response:
        pass

