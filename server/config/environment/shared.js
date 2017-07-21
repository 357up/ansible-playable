'use strict';

exports = module.exports = {
  version: 'Alpha',
  // List of user roles
  userRoles: ['guest', 'user', 'admin'],
  'scriptEngine': {
    'host': process.env.SCRIPT_ENGINE_HOST || 'localhost',
    'user': process.env.SCRIPT_ENGINE_USER || 'root',
    // This is the default root password for local container set during docker container rebuild
    'password': process.env.SCRIPT_ENGINE_PASSWORD || 'P@ssw0rd@123'
  },

  paths: {
    local_server_logfile: './logs/server.log',
    local_express_server_logfile: './logs/server-api.log',
    ansible_projects: '/opt/ansible-projects',
    ansible_projects_arhive: '/archive', // relative to projects folder
    ansible_custom_api_local: './helpers/AnsibleAPI.py',
    ansible_custom_api_remote: '/tmp/AnsibleAPI.py',
    ansible_dir_tree_local: './helpers/dir_tree.py',
    ansible_dir_tree_remote: '/tmp/dir_tree.py',
    ansible_list_tasks_json_local: './helpers/list_tasks_json.py',
    ansible_list_tasks_json_remote: '/tmp/list_tasks_json.py',
    ansible_project_library: '/library', // relative to project folder
    ansible_project_roles: '/roles', // relative to project folder

  },

  disablePlayboookExecution: process.env.DISABLE_PLAYBOOK_EXECUTION || false,
  // Disable adding a separate ansible host than localhost
  disableAnsibleHostAddition: process.env.DISABLE_ANSIBLE_HOST_ADDITION || false,

  videos
:
[
  {
    title: 'Overview',
    type: 'overview',
    video_id: 'elO8vR5G6n4'
  },
  {
    title: 'Getting Started',
    type: 'getting_started',
    video_id: 'ze5BWEQ1RJw'
  },
  {
    title: 'Google Cloud Example',
    type: 'google_cloud',
    video_id: 'QQuA0EHIijo'
  }/*,
  {
    title: 'VMWare Example',
    type: 'vmware'
  },
  {
    title: 'Custom Modules',
    type: 'custom_module'
  }*/
]

}
;
