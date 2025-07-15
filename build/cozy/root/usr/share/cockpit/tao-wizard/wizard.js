import * as service from "./lib/service.js";

let resourcesPollingInterval = null;

const DEPS_SERVICES = [
	"elasticsearch.service",
	"redis.service",
	"pgsql.service",
	"pubsub-emulator.service",
	"firestore-emulator.service",
	'k3s.service',
];

// const RESOURCES = [
// 	"statefulset.apps/tao-ce-tao",
// 	"statefulset.apps/tao-ce-tao-deliver-be",
// 	"statefulset.apps/tao-ce-tao-scoring-service",
// 	"statefulset.apps/tao-ce-tao-simple-reports-be",
// 	"deployment.apps/tao-ce-devkit-lti1p3",
// 	"deployment.apps/tao-ce-em-auth-server",
// 	"deployment.apps/tao-ce-em-lti-gateway",
// 	"deployment.apps/tao-ce-em-sidecar",
// 	"deployment.apps/tao-ce-envoy",
// 	"deployment.apps/tao-ce-jsreport",
// 	"deployment.apps/tao-ce-rt-timers",
// 	"deployment.apps/tao-ce-tao-datastore-worker",
// 	"deployment.apps/tao-ce-tao-deliver-fe-bootstrap",
// 	"deployment.apps/tao-ce-tao-deliver-fe-static",
// 	"deployment.apps/tao-ce-tao-deliver-sandbox",
// 	"deployment.apps/tao-ce-tao-dynamic-query-api",
// 	"deployment.apps/tao-ce-tao-hierarchy-be",
// 	"deployment.apps/tao-ce-tao-manual-scoring",
// 	"deployment.apps/tao-ce-tao-portal-be",
// 	"deployment.apps/tao-ce-tao-portal-bootstrap",
// 	"deployment.apps/tao-ce-tao-portal-static",
// 	"deployment.apps/tao-ce-tao-task-orchestrator-be",
// ];

const ACTIONS = [
	{
		"id": "em-preload",
		"name": "Reload authentication",
		"action": () => {
			cockpit.spawn(["/bin/sh", "em-preload.sh"], {"directory": "/var/lib/tao-ce/tasks"})
				.then(() => {logAction("Successfully run em-preload")})
				.catch(() => {logAction("Error while running em-preload")})
		},
		"description": "Reload authentication",
	},
	{
		"id": "install-construct",
		"name": "Install TAO Construct",
		"action": () => {
			cockpit.spawn(["/bin/sh", "install-construct.sh"], {"directory": "/var/lib/tao-ce/tasks"})
				.then(() => {logAction("Successfully run install-construct")})
				.catch(() => {logAction("Error while running install-construct")})
		},
		"description": "Reset all users",
	},
	{
		"id": "reset-users",
		"name": "Reset users",
		"action": () => {
			cockpit.spawn(["/bin/sh", "reset-users.sh"], {"directory": "/var/lib/tao-ce/tasks"})
				.then(() => {logAction("Successfully run reset-users")})
				.catch(() => {logAction("Error while running reset-users")})
		},
		"description": "Reset all users",
	},
];

function logAction(log) {
	console.log(log);
}


function listenResources(s) {
	if(s) {
		if(resourcesPollingInterval === null) {
			resourcesPollingInterval = setInterval(updateResources, 5000);
			updateResources();
			console.log("Start watching k8s resources");
		}
	}
	else {
		clearInterval(resourcesPollingInterval);
		resourcesPollingInterval= null;
		console.log("Stop watching k8s resources");
	}
	
}

function initResources() {
	const proxy = service.proxy("k3s.service");
	proxy.addEventListener('changed', event => {
		listenResources(proxy.state == "running");
	});

}

function updateResources() {
	cockpit.script("kubectl get deploy,sts,ds -o json | jq '[.items[] | {kind: .kind, name: .metadata.name, status: (.status.availableReplicas //  0)}]'", {err: "message"}).then((data,message) => {
		console.log(data);
		console.error(message);

		const statuses = JSON.parse(data);
		
		const statusesRow = statuses.map((status) => {
			const row = document.createElement('tr');
			row.setAttribute('id', 'resource-'+status.kind+"-"+status.name );
			const kindCell = document.createElement('td');
			kindCell.innerHTML = status.kind;
			const nameCell = document.createElement('td');
			nameCell.innerHTML = status.name;
			const statusCell = document.createElement('td');
			statusCell.innerHTML = status.status > 0 ? "ok" : "?";
			row.replaceChildren(kindCell, nameCell, statusCell);
			return row;
		});

		document.getElementById('resources-table-body').replaceChildren(...statusesRow);
	})
}

function initServices() {
	DEPS_SERVICES.forEach((svc) => {
		const proxy = service.proxy(svc);
		proxy.addEventListener('changed', event => { updateSvc(svc, proxy) });
		
		const row = document.createElement('tr');
		row.setAttribute('id', 'svc-'+ svc);
		document.getElementById('services-table-body').appendChild(row);

	});
}

function initActions() {
	ACTIONS.forEach((action) => {
		const row = document.createElement('tr');
		row.setAttribute('id', 'action-'+ action.id);
		const nameCell = document.createElement('td');
		const runButton = document.createElement('button');
		runButton.innerHTML = action.name;
		runButton.addEventListener('click', action.action);
		nameCell.appendChild(runButton);
		const descCell = document.createElement('td');
		descCell.innerHTML = action.description;
		row.replaceChildren(nameCell, descCell);
		document.getElementById('actions-table-body').appendChild(row);
	});
}

// function initManifest() {
// 	const pre = document.createElement('textarea');
// 	pre.innerHTML = "Press refresh";
// 	pre.setAttribute('id', 'manifest-body');
// 	document.getElementById('manifest').replaceChildren(pre);
// }

// function updateManifest() {
// 	document.getElementById('manifest-body').innerHTML = "";
//     cockpit.spawn(["kubectl", "get", "-o", "json", "secret/foo", ]).stream((data) => {
// 	document.getElementById('manifest-body').innerHTML += data
//     });
// }

function updateSvc(svc, proxy) {
	const row = document.getElementById('svc-' + svc);

	const nameCell = document.createElement('td');
	nameCell.innerHTML = ( proxy.unit ) ? proxy.unit.Description :  svc;

	const stateCell = document.createElement('td');
	stateCell.innerHTML = proxy.state;

	const memCell = document.createElement('td');
	memCell.innerHTML = (proxy.state === 'running' && proxy.details ) ? Math.ceil(proxy.details.MemoryCurrent / 1048576 ) + ' MB' : 'N/A';

	row.replaceChildren(nameCell, stateCell, memCell);
}

document.addEventListener("DOMContentLoaded", () => {
	initServices();
	initActions();
	initResources();
	// initManifest();

    	// document.getElementById('refresh').addEventListener('click', updateManifest);
});



cockpit.transport.wait(function() {



});
