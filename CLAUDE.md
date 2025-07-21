**General Rules**
0. Start by first creating the .env file for everything needed below
1. we should always use git and github
2. if you do not have a github repo setup, we should do that before anything else.
3. if creating multiple agents, each agent should have their own folder
4. create a chroma db that every agent writes vectorized reports to; the db should be named chisel_db and the agent who should read/write to it will be named Chisel. No app should be allowed to erase from chisel without my special passcode. The passcode will be in the .env file; prompt the user for the passcode if any agent or program attempts to delete from chisel_db
5. ChatGPT is the LLM of choice; we have API access in the .env file
6. Project requirements will be stored in a file named prd_agentname.md in the same folder as the agent where "agentname" will be replaced with the name of the agent.
7. The first step before writing any code will be to refine the prd file. You should as a minimum of 10, but no more than 20 clariying questions about the prd before writing any code.
8. After I have answered a minimum of 10 clarifying questions and you feel that you have an understanding ; based on any changes in your understanding of the PRD re-write the PRD as "prd_agentname_refined.md"
9. if at any point you feel like you have enough understanding to make a good attempt at an excellent result, you may say so.

**coding guidelines**
1. write tests based on expected input/output pairs
2. Tell Claude to run the tests and confirm they fail
3. commit the tests when we are satisfied
4. write code that passes the tests
5. Commit the code

**Frequently Used Tools and Libraries We May Need**
Chromadb, Langchain, Langraph, IMAP, streamlit, xcode, git, github

**dealing with humans asking you questions**
1. Each time a new app is created, you should list the name of the app and how to start it in a new .md file named "app_list.md" 
2. You have permission to update app_list.md without asking for permission
3. The human user will often ask you how to start a program we've created; immediately refer to app_list.md and only provide answers from app_list.md