const https = require('https');

exports.handler = async (event) => {
  try {
    
    const clientId = process.env.CLIENT_ID;
    const clientSecret = process.env.CLIENT_SECRET;
    const org = process.env.ORG_NAME;
    const repo = process.env.REPO_NAME;
    
    // Generate a new Bitbucket token using https request
    const options = {
      hostname: 'bitbucket.org',
      path: '/site/oauth2/access_token',
      method: 'POST',
      auth: `${clientId}:${clientSecret}`,
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: 'grant_type=client_credentials',
    };

    const response = await httpRequest(options);

    // Extract the access token from the Bitbucket response
    const accessToken = JSON.parse(response).access_token;

    // Remove existing webhooks
    await removeWebhooks(repo, org, accessToken);

    // Update the Amplify application with the new token
    const updateParams = {
      appId: process.env.AMPLIFY_APP_ID,
      oauthToken: accessToken,
    };

    // Call the Amplify updateApplication API
    await updateAmplifyApp(updateParams);

    return {
      statusCode: 200,
      body: 'Bitbucket token updated successfully',
    };
  } catch (error) {
    console.error('Error updating Bitbucket token:', error);
    return {
      statusCode: 500,
      body: 'Error updating Bitbucket token',
    };
  }
};

// Helper function to remove existing webhooks created by Amplify
function removeWebhooks(repo, org, token) {
    const options = {
      hostname: 'api.bitbucket.org',
      path: `/2.0/repositories/${org}/${repo}/hooks`,
      method: 'GET',
      headers: {
        'Content-Type': 'application/json',
        Authorization: `Bearer ${token}`,
      },
    };
  
    return httpRequest(options)
      .then((response) => {
        const hooks = JSON.parse(response).values;
        const webhookPromises = hooks.map((hook) => {
          if (hook.description === 'Web hook created by AWS Amplify Console') {
            const deleteOptions = {
              hostname: 'api.bitbucket.org',
              path: `/2.0/repositories/${org}/${repo}/hooks/${hook.uuid}`,
              method: 'DELETE',
              headers: {
                'Content-Type': 'application/json',
                Authorization: `Bearer ${token}`,
              },
            };

            return httpRequest(deleteOptions);
          }
        });
        return Promise.all(webhookPromises);
      });
}

// Helper function to send an HTTPS request
function httpRequest(options) {
  return new Promise((resolve, reject) => {
    const req = https.request(options, (res) => {
      let data = '';

      res.on('data', (chunk) => {
        data += chunk;
      });

      res.on('end', () => {
        resolve(data);
      });
    });

    req.on('error', (error) => {
      reject(error);
    });

    if (options.body) {
      req.write(options.body);
    }

    req.end();
  });
}

// Helper function to update Amplify application
function updateAmplifyApp(params) {
  const AWS = require('aws-sdk');
  const amplify = new AWS.Amplify();
  return amplify.updateApp(params).promise();
}