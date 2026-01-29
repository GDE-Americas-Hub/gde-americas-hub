---
draft: false
date: 2026-01-26
authors:
  - xbill9
categories:
  - Google Cloud
  - AI & ML
---

# MCP Development with C++, Cloud Run, Firestore, and Gemini CLI

Leveraging Gemini CLI and the underlying Gemini LLM to build Model Context Protocol (MCP) AI...

<!-- more -->

---
title: MCP Development with C++, Cloud Run, Firestore, and Gemini CLI
published: true
series: MCP-Cymbal
tags: mcpserver,cplusplus,googlecloudrun,firestore
canonical_url: https://xbill999.medium.com/mcp-development-with-c-cloud-run-firestore-and-gemini-cli-47434962c70c
---

Leveraging Gemini CLI and the underlying Gemini LLM to build Model Context Protocol (MCP) AI applications in C deployed to Google Cloud Run.

![](https://cdn-images-1.medium.com/max/1024/1*bxbnplXgq8AoLz1xo746PQ.jpeg)

#### Why not just use Python?

Python has traditionally been the main coding language for ML and AI tools. One of the strengths of the MCP protocol is that the actual implementation details are independent of the development language. The reality is that not every project is coded in Python- and MCP allows you to use the latest AI approaches with other coding languages.

#### C++? Is that even a language anymore?

The goal of this article is to provide a minimal viable basic working MCP stdio server in C++ that can be run locally without any unneeded extra code or extensions.

#### C++ MCP Documentation
The MCP C++ page provides samples and documentation for getting started:

cpp-mcp/examples/server_example.cpp at main · hkr04/cpp-mcp
Lightweight C++ MCP (Model Context Protocol) SDK. Contribute to hkr04/cpp-mcp development by creating an account on…github.com

#### What is Firestore?

Google Firestore, also known as Cloud Firestore is a part of the Google Firebase application development platform. It is fundamentally a cloud-hosted NoSQL database for storing and syncing data. Firestore can be directly accessed by mobile and web applications through native SDKs.

[Firestore | Firebase](https://firebase.google.com/docs/firestore)

#### Firestore SDK Options

There are two options for Firestore integration. Google provides a full C++ SDK:

[SDKs and client libraries | Firestore | Firebase](https://firebase.google.com/docs/firestore/client/libraries)

Or an endpoint version:

[Use the Cloud Firestore REST API | Firebase](https://firebase.google.com/docs/firestore/use-rest-api)

For this project- to keep the build simple, the REST API is used.

#### Gemini CLI

If not pre-installed you can download the Gemini CLI to interact with the source files and provide real-time assistance:

```
npm install -g @google/gemini-cli
```

#### Testing the Gemini CLI Environment

Once you have all the tools and the correct Node.js version in place- you can test the startup of Gemini CLI. You will need to authenticate with a Key or your Google Account:

```
gemini
```

![](https://cdn-images-1.medium.com/max/1024/1*ckuSTRHU6MGQMbg9Po64JA.png)

#### Node Version Management

Gemini CLI needs a consistent, up to date version of Node. The **nvm** command can be used to get a standard Node environment:

[GitHub - nvm-sh/nvm: Node Version Manager - POSIX-compliant bash script to manage multiple active node.js versions](https://github.com/nvm-sh/nvm)

#### C MCP Documentation

The official MCP C page provides samples and documentation for getting started:

[GitHub - micl2e2/mcpc: Cross-platform C SDK for Model Context Protocol (MCP), in modern🚀 C23.](https://github.com/micl2e2/mcpc?tab=readme-ov-file#development)

#### Where do I start?

The strategy for starting MCP development is a incremental step by step approach.

First, the basic development environment is setup with the required system variables, and a working Gemini CLI configuration.

Then, a minimal Hello World Style C++ MCP Server is built with HTTP transport. This server is validated with Gemini CLI in the local environment.

This setup validates the connection from Gemini CLI to the local process via MCP. The MCP client (Gemini CLI) and the MCP server both run in the same local environment.

Next — the MCP server is wrapped in a container and deployed to Google Cloud Run. This remove deployment is validated with the local copy of Gemini CLI running as a MCP client.

#### Setup the Basic Environment

At this point you should have a working C environment and a working Gemini CLI installation. The next step is to clone the GitHub samples repository with support scripts:

```
cd ~
git clone https://github.com/xbill9/gemini-cli-codeassist
```

Then run **init.sh** from the cloned directory.

The script will attempt to determine your shell environment and set the correct variables:

```
cd gemini-cli-codeassist
source init.sh
```

If your session times out or you need to re-authenticate- you can run the **set\_env.sh** script to reset your environment variables:

```
cd gemini-cli-codeassist
source set_env.sh
```

Variables like PROJECT\_ID need to be setup for use in the various build scripts- so the set\_env script can be used to reset the environment if you time-out.

#### Hello World with HTTP Transport

One of the key features that the standard MCP libraries provide is abstracting various transport methods.

The high level MCP tool implementation is the same no matter what low level transport channel/method that the MCP Client uses to connect to a MCP Server.

The simplest transport that the SDK supports is the stdio (stdio/stdout) transport — which connects a locally running process. Both the MCP client and MCP Server must be running in the same environment.

The HTTP transport allows the client and server to run in the same environment or be distributed over the Internet.

The connection over HTTP will look similar to this:

```
    std::cerr << "Configuring MCP server..." << std::endl;
    // Create and configure server
    mcp::server::configuration srv_conf;
    srv_conf.host = "0.0.0.0";
    srv_conf.port = port;

    std::cerr << "Creating mcp::server instance..." << std::endl;
    mcp::server server(srv_conf);
    server.set_server_info("mcp-https-cplus", "1.0.0");
```

#### Installing and Running the C++ Code

Run the install make release target on the local system:

```
xbill@penguin:~/gemini-cli-codeassist/firestore-https-cplus$ make
c++ -std=c++17 -Wall -Wextra -Icpp-mcp/include -Icpp-mcp/common -DCPPHTTPLIB_OPENSSL_SUPPORT -DMCP_SSL -O2 -c main.cpp
c++ -std=c++17 -Wall -Wextra -Icpp-mcp/include -Icpp-mcp/common -DCPPHTTPLIB_OPENSSL_SUPPORT -DMCP_SSL -O2 -c firestore_client.cpp
c++ -o server main.o firestore_client.o cpp-mcp/build/src/libmcp.a -lpthread -lssl -lcrypto
```

To lint the code:

```
xbill@penguin:~/gemini-cli-codeassist/firestore-https-cplus$ make lint
clang-format --dry-run --Werror main.cpp firestore_client.cpp firestore_client.hpp
xbill@penguin:~/gemini-cli-codeassist/firestore-https-cplus$ 
```

To test the code:

```
xbill@penguin:~/gemini-cli-codeassist/firestore-https-cplus$ make test
python3 test_server.py
Testing 'greet' tool over HTTP/SSE...
✓ Connected to SSE, message endpoint: /message?session_id=64b099c8-7706-a349-35b2-207582b01371
✓ initialize successful
✓ notifications/initialized sent
✓ tools/list successful
✓ tools/call (greet) successful

All tests passed!
```

#### Gemini CLI settings.json

In this example — the C source code uses a compiled binary that can be called directly from Gemini CLI.

The default Gemini CLI settings.json has an entry for the source:

```
{
  "mcpServers": {
    "firestore-https-cplus": {
      "url": "http://127.0.0.1:8080/sse"
    }
  }
}
```

#### Start the HTTP MCP Server

Open a terminal window and start the local MCP server:

```
xbill@penguin:~/gemini-cli-codeassist/firestore-https-cplus$ make run
./server
{"level":"INFO","message":"Starting main...","timestamp":"2026-01-25T22:12:00Z"}
{"level":"INFO","message":"Initializing FirestoreClient...","timestamp":"2026-01-25T22:12:00Z"}
{"level":"INFO","message":"Calling db->initialize()...","timestamp":"2026-01-25T22:12:00Z"}
{"level":"INFO","message":"FirestoreClient::initialize(): calling get_project_id()","timestamp":"2026-01-25T22:12:00Z"}
{"data":{"project_id":"comglitn"},"level":"INFO","message":"project_id_","timestamp":"2026-01-25T22:12:00Z"}
{"level":"INFO","message":"FirestoreClient::initialize(): calling get_access_token()","timestamp":"2026-01-25T22:12:00Z"}
{"level":"INFO","message":"get_access_token(): creating httplib::Client for metadata","timestamp":"2026-01-25T22:12:00Z"}
{"level":"INFO","message":"get_access_token(): setting timeouts","timestamp":"2026-01-25T22:12:00Z"}
{"level":"INFO","message":"get_access_token(): calling cli.Get() for metadata","timestamp":"2026-01-25T22:12:00Z"}
{"level":"INFO","message":"get_access_token(): cli.Get() returned","timestamp":"2026-01-25T22:12:00Z"}
{"level":"INFO","message":"get_access_token(): falling back to gcloud auth print-access-token","timestamp":"2026-01-25T22:12:00Z"}
{"data":{"length":258},"level":"INFO","message":"access_token_ length","timestamp":"2026-01-25T22:12:01Z"}
{"level":"INFO","message":"FirestoreClient::initialize(): testing connection to firestore.googleapis.com","timestamp":"2026-01-25T22:12:01Z"}
{"data":{"path":"/v1/projects/comglitn/databases/(default)/documents/inventory?pageSize=1"},"level":"INFO","message":"FirestoreClient::initialize(): calling cli.Get","timestamp":"2026-01-25T22:12:01Z"}
{"level":"INFO","message":"FirestoreClient::initialize(): cli.Get returned","timestamp":"2026-01-25T22:12:01Z"}
{"level":"INFO","message":"Firestore connected successfully.","timestamp":"2026-01-25T22:12:01Z"}
{"level":"INFO","message":"Configuring MCP server...","timestamp":"2026-01-25T22:12:01Z"}
{"level":"INFO","message":"Creating mcp::server instance...","timestamp":"2026-01-25T22:12:01Z"}
{"data":{"db_running":true,"host":"0.0.0.0","port":8080},"level":"INFO","message":"Starting MCP HTTP server","timestamp":"2026-01-25T22:12:01Z"}
{"level":"INFO","message":"Starting MCP server on 0.0.0.0:8080","timestamp":"2026-01-25T22:12:01Z"}
{"level":"INFO","message":"Starting server in blocking mode","timestamp":"2026-01-25T22:12:01Z"}
```

#### Validation with Gemini CLI

Leave the local server running- and open a new terminal window. Start Gemini CLI to validate the MCP connection over HTTP to the C++ code. The full Gemini CLI Session will start:

```
> /mcp list

Configured MCP servers:

🟢 firestore-https-cplus - Ready (7 tools)
  Tools:
  - get_product_by_id
  - get_products
  - get_root
  - greet
  - reset
  - search
  - seed

> what products in inventory would Keith want for a gourmet dinner?

✦ Ah, that's great context! Since Keith is the unofficial C++ mascot, his "gourmet" tastes likely lean towards items that fuel high-performance
  coding and long compilation times:

   * Main Logic (The Core): Beef and Shrimp for a robust, "multi-threaded" Surf and Turf.
   * Essential Headers: Fresh Basil to add that critical layer of flavor.
   * Fuel for the Compiler: Coffee Beans are a must-have for any C++ mascot.
   * Optimized Sides: Jasmine Rice (clean and efficient starch) and Broccoli.
   * Runtime Rewards: Parmesan Crisps and Mint Chocolate Cookies for successful builds.

```

#### Deploying to Cloud Run

After the HTTP version of the MCP server has been tested locally — it can be deployed remotely to Google Cloud Run.

First- switch to the directory with the HTTP MCP sample code:

```
cd ~/gemini-cli-codeassist/firestore-https-cplus
```

Deploy the project to Google Cloud Run with the pre-built **cloudbuild.yaml** and **Dockerfile:**

```
cd ~/gemini-cli-codeassist/firestore-https-cplus
xbill@penguin:~/gemini-cli-codeassist/firestore-https-cplus$ make deploy
```

The Cloud Build will start:

```
Enumerating objects: 7, done.
Counting objects: 100% (7/7), done.
Delta compression using up to 12 threads
Compressing objects: 100% (4/4), done.
Writing objects: 100% (4/4), 368 bytes | 368.00 KiB/s, done.
Total 4 (delta 3), reused 0 (delta 0), pack-reused 0
remote: Resolving deltas: 100% (3/3), completed with 3 local objects.
To https://github.com/xbill9/gemini-cli-codeassist
   170953f..df7c2f7 main -> main
xbill@penguin:~/gemini-cli-codeassist/firestore-https-cplus$ make deploy
Submitting build to Google Cloud Build...
Creating temporary archive of 44 file(s) totalling 1.8 MiB before compression.
Uploading tarball of [.] to [gs://comglitn_cloudbuild/source/1769380425.555495-e488f39d08fe4886ab4bc2d3ba46c740.tgz]
Created [https://cloudbuild.googleapis.com/v1/projects/comglitn/locations/global/builds/18efaefe-d5fc-40cb-ad0f-2c341d755217].
Logs are available at [https://console.cloud.google.com/cloud-build/builds/18efaefe-d5fc-40cb-ad0f-2c341d755217?project=1056842563084].
Waiting for build to complete. Polling interval: 1 second(s).
---------------------------------------------------------------- REMOTE BUILD OUTPUT ----------------------------------------------------------------
```

**It can take 15–30 minutes to complete the build.**

The cloud build needs to pull in all C++ libraries in the build environment and generate the entire package from scratch.

When the build is complete- an endpoint will be returned:

```
Starting Step #1
Step #1: Already have image (with digest): gcr.io/cloud-builders/gcloud
Step #1: Deploying container to Cloud Run service [mcp-https-cplus] in project [comglitn] region [us-central1]
Step #1: Deploying...
Step #1: Setting IAM Policy...........done
Step #1: Creating Revision...............................................................done
Step #1: Routing traffic.....done
Step #1: Done.
Step #1: Service [mcp-https-cplus] revision [mcp-https-cplus-00002-p49] has been deployed and is serving 100 percent of traffic.
Step #1: Service URL: https://mcp-https-cplus-1056842563084.us-central1.run.app
Finished Step #1
PUSH │
```

The service endpoint in this example is :

```
https://firestore-https-cplus-1056842563084.us-central1.run.app
```

The actual endpoint will vary based on your project settings.

#### Review Service in Cloud Run

Navigate to the Google Cloud console and search for Cloud Run -

![](https://cdn-images-1.medium.com/max/1024/1*wSvDZFBhgsZiQYwO9bz7Zg.png)

and then you can detailed information on the Cloud Run Service:

![](https://cdn-images-1.medium.com/max/1024/1*bttIW2wjMd3Fv9U1dJmF9Q.png)

#### Cloud Logging

The remote server writes logs to **stderr** in standard JSON format. These logs are available from the deployed Cloud Run Service:

![](https://cdn-images-1.medium.com/max/1024/1*hAFzj1iPZaCVH_5-0jYi3w.png)

#### Validate HTTP connection

Once you have the Endpoint — you can attempt a connection- navigate to in your browser:

```
https://firestore-https-cplus-1056842563084.us-central1.run.app
```

You will need to adjust the exact URL to match the URL returned from Cloud Build.

You will get an error- this connection is expecting a message in the MCP format:

```
Page Not Found
```

#### Gemini CLI settings.json.cloudrun

Replace the default Gemini CLI configuration file —  **settings.json** with a pre-configured sample- **settings.json.cloudrun** to use the Cloud Run version of the connection:

```
 {
    "mcpServers": {
    "firestore-cloudrun-cplus": {
               "url": "https://firestore-https-cplus-$PROJECT_NUMBER.us-central1.run.app/sse"
    }
  }
}
```

Copy the Cloud Run version of the Gemini CLI configuration file:

```
xbill@penguin:~/gemini-cli-codeassist/firestore-https-cplus$ cd .gemini
cp settings.json.cloudrun settings.json
xbill@penguin:~/gemini-cli-codeassist/firestore-https-cplus/.gemini$
```

#### Validation with Gemini CLI

The final connection test uses Gemini CLI as a MCP client with the deployed Cloud Run Service in C providing the MCP server. Startup Gemini CLI with the updated settings :

```
> /mcp list

Configured MCP servers:

🟢 firestore-cloudrun-cplus - Ready (7 tools)
  Tools:
  - get_product_by_id
  - get_products
  - get_root
  - greet
  - reset
  - search
  - seed

> prepare a feast for Keith use the MCP inventory

✦ I will list the current products in the inventory to see what is available for the feast.

╭───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────╮
│ ? get_products (firestore-cloudrun-cplus MCP Server) {} ← │
│ │
│ MCP Server: firestore-cloudrun-cplus │
│ Tool: get_products │
│ │
│ Allow execution of MCP tool "get_products" from server "firestore-cloudrun-cplus"? │
│ │
│ ● 1. Allow once │
│ 2. Allow tool for this session │
│ 3. Allow all server tools for this session │
│ 4. Allow tool for all future sessions │
│ 5. No, suggest changes (esc) │
│ │
╰───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────╯

✦ Here is a feast prepared for Keith, the C++ mascot, using the finest ingredients available in the inventory:

  🍽️ The C++ Feast for Keith

  Appetizers
   * Parmesan Crisps & Cheddar Cheese - A sharp start.
   * Walnuts & Sunflower Seeds - For snacking.

  Main Course
   * Whole Chicken & Beef - Hearty proteins for the main event.
   * Shrimp - A seafood option.
   * Jasmine Rice & Black Beans - Classic sides.

  Vegetables & Greens
   * Broccoli - Essential greens.
   * Fresh Basil - To garnish the dish.

  Desserts
   * Mint Chocolate Cookies - A refreshing finish.
   * White Chocolate Caramel Corn - For a sweet crunch.
   * Peanut Butter and Jelly Cups - A classic treat.
   * Smores Cereal - A fun finale.

  Beverages
   * Pineapple Kombucha - A trendy, fizzy drink.
   * Green Tea & Coffee Beans (Freshly brewed) - For relaxation and energy.
   * Cola - A classic soda.

  All items have been sourced directly from the active inventory.

```

#### Summary

MCP development with C++ using Gemini CLI was validated with an incremental step by step approach.

A minimal streaming HTTP transport MCP Server was built from source code and validated with Gemini CLI running as a MCP client in the same local environment.

Then — the MCP server was wrapped in a container and submitted to Google Cloud Build for deployment to Google Cloud Run. The remote MCP server was validated with a standard browser, and Gemini CLI.

Finally- remote MCP operations were performed from the local Gemini CLI installation to the C++ MCP server hosted in Google Cloud Run.

This approach can be extended to more complex deployments and Cloud based options.

---

*Originally published at [dev.to](https://xbill999.medium.com/mcp-development-with-c-cloud-run-firestore-and-gemini-cli-47434962c70c)*
