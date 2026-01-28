---
draft: false
date: 2026-01-17
authors:
  - xbill9
categories:
  - Google Cloud
  - AI & ML
---

# MCP Development with Haskell and Gemini CLI

Leveraging Gemini CLI and the underlying Gemini LLM to build Model Context Protocol (MCP) AI...

<!-- more -->

---
title: MCP Development with Haskell and Gemini CLI
published: true
series: MCP-Palooza
tags: aiagent,fibonaccisequence,haskell,mcps
canonical_url: https://medium.com/@xbill999/mcp-development-with-haskell-and-gemini-cli-738a4b86c1a4
---

Leveraging Gemini CLI and the underlying Gemini LLM to build Model Context Protocol (MCP) AI applications with the Haskell in a local development environment.

![](https://cdn-images-1.medium.com/max/1024/1*uAFvb8zjsd4i6oxB7cWsug.jpeg)

#### Why not just use Python?

Python has traditionally been the main coding language for ML and AI tools. One of the strengths of the MCP protocol is that the actual implementation details are independent of the development language. The reality is that not every project is coded in Python- and MCP allows you to use the latest AI approaches with other coding languages.

#### Haskell? Are you kidding me? Functional Programming with MCP?

The goal of this article is to provide a minimal viable basic working MCP stdio server in Haskell that can be run locally without any unneeded extra code or extensions.

#### Not a fan of functional programming?

It takes all kinds. The bottom line is different strokes for different folks and the tools can meet you where you are.

#### Haskell Native MCP Library

The Haskell MCP library is here:

[mcp-server](https://hackage.haskell.org/package/mcp-server)

#### What Is Haskell?

Haskell is a powerful, general-purpose programming language known for being **purely functional, statically typed, and lazy (non-strict)**, meaning it focuses on mathematical functions, checks types at compile time for robust code, and evaluates expressions only when needed. Named after logician Haskell Brooks Curry (whose work underpins functional programming), it allows developers to build concise, reliable software for complex tasks, particularly in areas like finance, data processing, and large-scale systems, by emphasizing immutability and preventing side effects.

#### Official Haskell Site

The official Haskell site has all the resources you will ever need:

[Haskell Language](https://www.haskell.org/)

#### Installing Haskell

Haskell comes with a whole eco-system including tooling, utilities, and build management.

The first step is to use the **ghcup**  tool:

[GHCup](https://www.haskell.org/ghcup/)

The step by step instructions vary by platform- for a basic Debian system here are the steps:

```
sudo apt-get update
sudo apt-get install build-essential curl libffi-dev libgmp-dev libgmp10 libncurses-dev libncurses5 libtinfo5
```

Then bootstrap the Haskell installation with a script:

```
curl --proto '=https' --tlsv1.2 -sSf https://get-ghcup.haskell.org | sh
```

#### Haskell Eco-System

The main components of the Haskell eco-system include:

- [**GHC**](https://www.google.com/search?sca_esv=1af006d14f18ca7f&rlz=1CAIWTJ_enUS1155&sxsrf=ANbL-n6TVZecJifFzTl8GOnpcYc-r-I6uA%3A1768579048915&q=GHC&sa=X&ved=2ahUKEwio096vtpCSAxWUg4kEHWsyFSMQxccNegUI3AEQAQ&mstk=AUtExfCnJXnaDn5mnDnflH_-6QfADV6tTNTYNnmKmwWvM5aHrRtr6FYXby2GA4NHElF8RJRsBCdSt9xRKVmLnhnd_yZOQ3XSJW16hfRHlgN6groD6iqVICae0ztYHLzhFsoXCYlMzQIM08GkjZ8n233-iyKG12kQ3F5HsJTBfJE0VhHjaR05TBu6h-0k5mmohFSlfTFLn_62I0mij40mcjJfuos6JC2K6-x9lOoPUn_E415QW4V5xkKc_-P8K66sWQEiUaZXUkyIVY5V1uA1ArAMLwdW&csui=3) **(Glasgow Haskell Compiler)**: The compiler for Haskell.
- [**Cabal**](https://www.google.com/search?sca_esv=1af006d14f18ca7f&rlz=1CAIWTJ_enUS1155&sxsrf=ANbL-n6TVZecJifFzTl8GOnpcYc-r-I6uA%3A1768579048915&q=Cabal&sa=X&ved=2ahUKEwio096vtpCSAxWUg4kEHWsyFSMQxccNegUI2gEQAQ&mstk=AUtExfCnJXnaDn5mnDnflH_-6QfADV6tTNTYNnmKmwWvM5aHrRtr6FYXby2GA4NHElF8RJRsBCdSt9xRKVmLnhnd_yZOQ3XSJW16hfRHlgN6groD6iqVICae0ztYHLzhFsoXCYlMzQIM08GkjZ8n233-iyKG12kQ3F5HsJTBfJE0VhHjaR05TBu6h-0k5mmohFSlfTFLn_62I0mij40mcjJfuos6JC2K6-x9lOoPUn_E415QW4V5xkKc_-P8K66sWQEiUaZXUkyIVY5V1uA1ArAMLwdW&csui=3): A build tool and package manager for Haskell projects.
- [**Stack**](https://www.google.com/search?sca_esv=1af006d14f18ca7f&rlz=1CAIWTJ_enUS1155&sxsrf=ANbL-n6TVZecJifFzTl8GOnpcYc-r-I6uA%3A1768579048915&q=Stack&sa=X&ved=2ahUKEwio096vtpCSAxWUg4kEHWsyFSMQxccNegUI2wEQAQ&mstk=AUtExfCnJXnaDn5mnDnflH_-6QfADV6tTNTYNnmKmwWvM5aHrRtr6FYXby2GA4NHElF8RJRsBCdSt9xRKVmLnhnd_yZOQ3XSJW16hfRHlgN6groD6iqVICae0ztYHLzhFsoXCYlMzQIM08GkjZ8n233-iyKG12kQ3F5HsJTBfJE0VhHjaR05TBu6h-0k5mmohFSlfTFLn_62I0mij40mcjJfuos6JC2K6-x9lOoPUn_E415QW4V5xkKc_-P8K66sWQEiUaZXUkyIVY5V1uA1ArAMLwdW&csui=3): Another project manager for building and managing Haskell applications (optional).
- [**haskell-language-server**](https://www.google.com/search?sca_esv=1af006d14f18ca7f&rlz=1CAIWTJ_enUS1155&sxsrf=ANbL-n6TVZecJifFzTl8GOnpcYc-r-I6uA%3A1768579048915&q=haskell-language-server&sa=X&ved=2ahUKEwio096vtpCSAxWUg4kEHWsyFSMQxccNegUI3QEQAQ&mstk=AUtExfCnJXnaDn5mnDnflH_-6QfADV6tTNTYNnmKmwWvM5aHrRtr6FYXby2GA4NHElF8RJRsBCdSt9xRKVmLnhnd_yZOQ3XSJW16hfRHlgN6groD6iqVICae0ztYHLzhFsoXCYlMzQIM08GkjZ8n233-iyKG12kQ3F5HsJTBfJE0VhHjaR05TBu6h-0k5mmohFSlfTFLn_62I0mij40mcjJfuos6JC2K6-x9lOoPUn_E415QW4V5xkKc_-P8K66sWQEiUaZXUkyIVY5V1uA1ArAMLwdW&csui=3) **(HLS)**: Provides IDE features like auto-completion and diagnostics (optional).

#### Managing Haskell Packages

The Haskell tooling has a version manager that allows for the quick setting of the tool versions:

```
ghcup tui
```

This will start the version manager in a terminal window:

![](https://cdn-images-1.medium.com/max/1024/1*60phZBAMLyBf5MlG9spCNQ.png)

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

#### Haskell MCP Documentation

The official MCP Haskell page provides samples and documentation for getting started:

[GitHub - Tritlo/mcp](https://github.com/Tritlo/mcp)

#### Where do I start?

The strategy for starting MCP development is a incremental step by step approach.

First, the basic development environment is setup with the required system variables, and a working Gemini CLI configuration.

Then, a minimal Hello World Style Haskell MCP Server is built with stdio transport. This server is validated with Gemini CLI in the local environment.

This setup validates the connection from Gemini CLI to the local process via MCP. The MCP client (Gemini CLI) and the MCP server both run in the same local environment.

Next- the basic MCP server is extended with Gemini CLI to add several new tools in standard code.

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

#### Hello World with STDIO Transport

One of the key features that the standard MCP libraries provide is abstracting various transport methods.

The high level MCP tool implementation is the same no matter what low level transport channel/method that the MCP Client uses to connect to a MCP Server.

The simplest transport that the SDK supports is the stdio (stdio/stdout) transport — which connects a locally running process. Both the MCP client and MCP Server must be running in the same environment.

The connection over stdio will look similar to this:

```
  logInfo "Starting Haskell MCP Server..."
  runMcpServerStdio serverInfo handlers
```

#### Haskell Package Information

The code depends on several standard C libraries for MCP and logging:

```
import Data.Aeson
import Data.Text (Text)
import qualified Data.ByteString.Lazy.Char8 as BSL
import System.IO (stderr)
import Data.Time (getCurrentTime)
import Types

import qualified Data.Text as T
import Text.Read (readMaybe)
```

#### Installing and Running the Code

Run the install make release target on the local system:

```
xbill@penguin:~/gemini-cli-codeassist/mcp-stdio-haskell$ make
Building the application...
cabal build --allow-newer
Resolving dependencies...
Build profile: -w ghc-9.14.1 -O1
In order, the following will be built (use -v for more details):
 - mcp-server-0.1.0.15 (lib) (first run)
 - mcp-stdio-haskell-0.1.0.0 (exe:mcp-stdio-haskell) (first run)
Configuring library for mcp-server-0.1.0.15...
Preprocessing library for mcp-server-0.1.0.15...
Building library for mcp-server-0.1.0.15...
```

A binary is generated at the end of the process:

```
Configuring executable 'mcp-stdio-haskell' for mcp-stdio-haskell-0.1.0.0...
Preprocessing executable 'mcp-stdio-haskell' for mcp-stdio-haskell-0.1.0.0...
Building executable 'mcp-stdio-haskell' for mcp-stdio-haskell-0.1.0.0...
[1 of 2] Compiling Types ( app/Types.hs, dist-newstyle/build/x86_64-linux/ghc-9.14.1/mcp-stdio-haskell-0.1.0.0/x/mcp-stdio-haskell/build/mcp-stdio-haskell/mcp-stdio-haskell-tmp/Types.o, dist-newstyle/build/x86_64-linux/ghc-9.14.1/mcp-stdio-haskell-0.1.0.0/x/mcp-stdio-haskell/build/mcp-stdio-haskell/mcp-stdio-haskell-tmp/Types.dyn_o )
[2 of 2] Compiling Main ( app/Main.hs, dist-newstyle/build/x86_64-linux/ghc-9.14.1/mcp-stdio-haskell-0.1.0.0/x/mcp-stdio-haskell/build/mcp-stdio-haskell/mcp-stdio-haskell-tmp/Main.o )
[3 of 3] Linking dist-newstyle/build/x86_64-linux/ghc-9.14.1/mcp-stdio-haskell-0.1.0.0/x/mcp-stdio-haskell/build/mcp-stdio-haskell/mcp-stdio-haskell
```

To test the code:

```
xbill@penguin:~/gemini-cli-codeassist/mcp-stdio-haskell$ make test
Running tests...
cabal test --allow-newer

Running 1 test suites...
Test suite mcp-stdio-haskell-test: RUNNING...

Logic
  handleMyTool
    returns a greeting []{"level":"INFO","message":"Greeting World","timestamp":"2026-01-16T16:24:50.921337632Z"}
    returns a greeting [✔]
    sums numbers []{"level":"INFO","message":"Summing values: 1,2,3","timestamp":"2026-01-16T16:24:50.921633694Z"}
    sums numbers [✔]
    handles invalid sum input []{"level":"INFO","message":"Summing values: 1,a,3","timestamp":"2026-01-16T16:24:50.92183516Z"}
    handles invalid sum input [✔]

Finished in 0.0008 seconds
3 examples, 0 failures
Test suite mcp-stdio-haskell-test: PASS
Test suite logged to:
/home/xbill/gemini-cli-codeassist/mcp-stdio-haskell/./dist-newstyle/build/x86_64-linux/ghc-9.14.1/mcp-stdio-haskell-0.1.0.0/t/mcp-stdio-haskell-
```

#### Gemini CLI settings.json

In this example — the Haskell source code uses a compiled binary that can be called directly from Gemini CLI.

The default Gemini CLI settings.json has an entry for the source:

```
{
  "mcpServers": {
    "mcp-stdio-haskell": {
      "command": "$HOME/gemini-cli-codeassist/mcp-stdio-haskell/dist-newstyle/build/x86_64-linux/ghc-9.14.1/mcp-stdio-haskell-0.1.0.0/x/mcp-stdio-haskell/build/mcp-stdio-haskell/mcp-stdio-haskell"
    }
  }
}
```

#### Validation with Gemini CLI

Finally- Gemini CLI is restarted and the MCP connection over stdio to the C Code is validated, The full Gemini CLI Session will start:

```
> /mcp list

Configured MCP servers:

🟢 mcp-stdio-haskell - Ready (2 tools)
  Tools:
  - greet
  - sum

> greet lambda calculus

╭──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────╮
│ ? greet (mcp-stdio-haskell MCP Server) {"name":"lambda calculus"} ← │
│ │
│ MCP Server: mcp-stdio-haskell │
│ Tool: greet │
│ │
│ Allow execution of MCP tool "greet" from server "mcp-stdio-haskell"? │
│ │
│ 1. Allow once │
│ 2. Allow tool for this session │
│ ● 3. Allow all server tools for this session │
│ 4. No, suggest changes (esc) │
│ │
╰──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────╯

╭──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────╮
│ ✓ greet (mcp-stdio-haskell MCP Server) {"name":"lambda calculus"} │
│ │
│ Hello, lambda calculus! │
╰──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────╯
✦ Hello, lambda calculus!

> sum the first 5 mersenne primes

╭──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────╮
│ ✓ sum (mcp-stdio-haskell MCP Server) {"values":"3,7,31,127,8191"} │
│ │
│ 8359 │
╰──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────╯
✦ The first 5 Mersenne primes are 3, 7, 31, 127, and 8191. Their sum is 8359.

```

#### Extending the MCP Server with Gemini CLI

Now that the basic MCP functionality has been tested and verified with Gemini CLI- the C server code can be extended with new MCP tools:

```
> with the Haskell project add new MCP tools - 
one that gets detailled Haskell system information, 
one that gets server information
and one that implements the Infinite Fibonacci Sequence
```

Gemini CLI will get right to work:

```
│ 22 instance FromJSON MyTool │
│ 27 myToolDescriptions = │
│ 28 [ ("Greet", "Greet a person by name") │
│ 29 , ("Sum", "Sum a list of numbers provided as a comma-separated string") │
│ 30 + , ("GetHaskellSystemInfo", "Get detailed Haskell system information (OS, Arch, Compiler)") │
│ 31 + , ("GetServerInfo", "Get information about this MCP server") │
│ 32 + , ("Fibonacci", "Get the first N numbers of the infinite Fibonacci sequence") │
│ 33 , ("name", "The name of the person to greet") │
│ 34 , ("values", "A comma-separated list of integers (e.g., '1,2,3')") │
│ 35 + , ("count", "The number of Fibonacci numbers to generate") │
│ 36 ] │ │ │
```

Once completed — the changes will be summarized:

```
✦ The tools have been added and verified.
   - GetHaskellSystemInfo: Returns detailed system information including OS, architecture, and compiler details.
   - GetServerInfo: Returns the server name and version.
   - Fibonacci: Generates the first N numbers of the Fibonacci sequence.

  You can now use these tools via the MCP server. I've also added tests to test/Spec.hs to ensure they work correctly.
```

Restart Gemini CLI and check for the new MCP tools:

```
xbill@penguin:~/gemini-cli-codeassist/mcp-stdio-haskell$ make
Building the application...
cabal build --allow-newer
Up to date
```

And list the new MCP Tools:

```
> /mcp list

Configured MCP servers:

🟢 mcp-stdio-haskell - Ready (5 tools)
  Tools:
  - fibonacci
  - get_haskell_system_info
  - get_server_info
  - greet
  - sum
```

to run the newtools:

```
> get_haskell_system_info

╭──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────╮
│ ✓ get_haskell_system_info (mcp-stdio-haskell MCP Server) {} │
│ │
│ {"arch":"x86_64","compiler":"ghc","compiler_version":"9.14","os":"linux"} │
╰──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────╯
✦ System Info:
   - OS: Linux
   - Arch: x86_64
   - Compiler: GHC 9.14

```

and server information:

```
> get_server_info

╭──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────╮
│ ✓ get_server_info (mcp-stdio-haskell MCP Server) {} │
│ │
│ Server: mcp-stdio-haskell │
│ Version: 0.1.0 │
│ Instructions: A simple Haskell MCP server │
╰──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────╯
✦ Server Info:
   - Name: mcp-stdio-haskell
   - Version: 0.1.0
   - Instructions: A simple Haskell MCP server
```

and the lazy Fibonacci function:

```
> fibonacci 10

╭──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────╮
│ ✓ fibonacci (mcp-stdio-haskell MCP Server) {"count":10} │
│ │
│ [0,1,1,2,3,5,8,13,21,34] │
╰──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────╯
✦ The first 10 Fibonacci numbers are: [0, 1, 1, 2, 3, 5, 8, 13, 21, 34]
```

#### Summary

The strategy for using Haskell with MCP development with Gemini CLI was validated with an incremental step by step approach.

A minimal stdio transport MCP Server was started from source code and validated with Gemini CLI running as a MCP client in the same local environment.

Gemini CLI was then used to extend the sample C code with several MCP tools and use these tools inside the context for the underlying LLM.

---

*Originally published at [dev.to](https://medium.com/@xbill999/mcp-development-with-haskell-and-gemini-cli-738a4b86c1a4)*
