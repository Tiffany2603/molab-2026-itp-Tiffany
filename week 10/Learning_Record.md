# Week 10 Learning Record

Project: **AI Job Application Assistant**

Resources: [Week 10 assignment](https://github.com/molab-itp/content-2026-itp/blob/main/weeks/10_multi.md#homework-week10), [my Notion proposal](https://app.notion.com/p/416a0e5b1afc801b9a92cd9b1ff014b6?pvs=204).

## Progress

I developed a final project proposal for an iOS app that brings job application updates, deadlines, personal experience, and interview preparation into one place. This replaces my earlier Sound Mood Map direction. The proposal includes the main screens, a dashboard concept, and a week-by-week implementation plan. The planned core demonstration is an authorized email becoming an application update and a task, followed by a phone reminder and user-confirmed completion.

## Problems

The project combines several systems: Gmail authorization, server-side email checking, AI extraction, cloud storage, and phone notifications. These integrations still need to be implemented and tested. Unclear email dates and instructions need user confirmation. A task that has been acknowledged must remain unfinished until the user marks it completed.

## Plans

Start with navigation, application records, and manual task entry. Then test AI extraction using sample emails, connect authorized Gmail test accounts, and add reminders. Build a text-based experience library and an editable interview-answer flow, with voice and file input added as time allows. The full schedule is in the [proposal](Final_Project_Proposal.md#week-by-week-work-plan).

## Questions

- How can an email be matched to an existing application without creating duplicates?
- How should an unclear deadline or application stage be shown for confirmation?
- How can follow-up reminders check completion and avoid unnecessary interruptions?
- How can interview-answer drafts make their source experiences clear?
