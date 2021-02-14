# Setting up your development environment 

## Install the sofware needed
To be able to develop ARM templates and GitHub workflows, we recommend you install the following software on your workstation:
  * [Git](https://git-scm.com/download/win)
  * [Visual Studio Code](https://code.visualstudio.com/Download)

Click on the links above and install the two packages by following the instructions provided.

Then start VS code and install your favorite extensions. Some of the ones we recommend are listed below:
  * [GitLens — Git supercharged](https://marketplace.visualstudio.com/items?itemName=eamodio.gitlens)
  * [Azure Resource Manager (ARM) Tools](https://marketplace.visualstudio.com/items?itemName=msazurermtools.azurerm-vscode-tools)
  * [YAML](https://marketplace.visualstudio.com/items?itemName=redhat.vscode-yaml)
  * [Markdown All in One](https://marketplace.visualstudio.com/items?itemName=yzhang.markdown-all-in-one)

# Clone your repository
Go to your github organization and make sure you have created a repository for your project by following the instructions provided in [Setup your GitHub Repository for IaC](../Docs/Setup-your-GitHub-Repository-for-IaC.md).

Go to your repo, click on the **Code** button and copy the URL displayed as shown below.

   <img src=".attachments/gitHub-clone.jpg" alt="GitHub-clone" title="GitHub Clone Repo"/>


Open VS Code, click on the *Source Control* icon and select **Clone Reporsitory**. Then paste the URL you copied in the previous step into the box displayed as shown below:

   <img src=".attachments/vs-code-clone.jpg" alt="VScode-clone" title="VScode Clone repo"/>

Then select the folder on your workspation where the repo will be cloned.

You are now ready to create a git branch for yourself in this repo and start contributing code. If you are not familiar with how version control works in Git or how to use it from VScode, please use the links below to ramp up:
  * [Git Basics](https://git-scm.com/book/en/v2/Git-Basics-Recording-Changes-to-the-Repository)
  * [Using version control in VS Code](https://code.visualstudio.com/Docs/editor/versioncontrol) 