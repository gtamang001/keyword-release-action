const core = require('@actions/core');
const github = require('@actions/github');

try {
    // get the matching keyword variable assigned
    const keyword = core.getInput('keyword');
    // get the GITHUB_TOKEN from input and use it to create an octokit client
    const GITHUB_TOKEN = core.getInput('GITHUB_TOKEN');
    const octokit = github.getOctokit(GITHUB_TOKEN);
    console.log(`Keyword checked against this ${keyword}!`);
    const { context } = require('@actions/github')
    console.log("Printing out context");
    console.log(context)
    console.log("Printing out the payload commit message");
    console.log(context.payload.commits.message)
    // adding comments for checking the values of commits object

} catch (error) {
    core.setFailed(error.message);
}