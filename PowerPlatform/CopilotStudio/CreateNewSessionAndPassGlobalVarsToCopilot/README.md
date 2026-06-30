# Summary
This sample shows how to set a global variable on creation of a session with Microsoft Copilot Studio.

# Use Case
Organizations need the ability to interact with Microsoft Copilot Studio topics and actions within Dataverse Model Apps. Organizations prefer the ability to customize the UI for the Copilot.

This sample shows key functionalities:
- Opening a Copilot Studio in a side pane when a case is opened.
- Keeping the state of the Copilot when case tabs/forms are changed.
- Passing variables to the Copilot without human interaction.
- Removing the side pane once the case form is closed.

# Steps
1. Create Global variable and set to allow external sources to set value. [Create variable](./CreateGlobalVarAndSetToExternalSources.png)
2. Create topic and add Question action.
3. Save response to global variable. [Save response to variable](./AddQuestionIntoTopic.png)
4. Use code from sample to create new session.
5. Start conversation and pass the variable.

# References
https://learn.microsoft.com/en-us/microsoft-copilot-studio/customize-default-canvas?tabs=web

https://microsoftcopilotstudio.microsoft.com/en-us/blog/make-your-power-virtual-agents-bot-start-the-conversation-using-a-custom-canvas/

https://powerusers.microsoft.com/t5/General/Parse-variable-to-a-new-chat/m-p/2462201/emcs_t/S2h8ZW1haWx8Ym9hcmRfc3Vic2NyaXB0aW9ufExQMlNYVFY1U1pYS1JafDI0NjIyMDF8U1VCU0NSSVBUSU9OU3xoSw#M7309
