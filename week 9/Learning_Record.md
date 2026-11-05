# Week 09 Learning Record

Learning resources: [Week09 — Multi User Experience](https://github.com/molab-itp/content-2026-itp/blob/main/weeks/09_multi.md), [class MoLobby](https://github.com/molab-itp/98-MoGallery-Private/tree/main/MoLobby)

Project: **Peer Help Lobby**

Goal: Make a shared board for asking for help, offering help, and sharing a status.

## Code Questions and Notes

### Three buttons, one input form

The buttons select Need Help, Can Help, or Share Status. ***@State*** keeps the category, text, and whether the form is open. ***.sheet*** opens the form, and ***$postText*** connects the multiline ***TextField*** to the input. This input pattern comes from the class ***UserDetailView***.

### Learning independent posts with ChatGPT

The class MoLobby saves one ***caption*** per user, so submitting another message replaces the previous one. I asked ChatGPT how to keep multiple messages, and it taught me to store each message as an independent post with its own ID. I used that explanation to add ***PostModel*** and a separate ***posts*** collection.

This independent-post design is an extension beyond the MoLobby example. It still uses the class Firestore writing and listening patterns, rather than a completely different database system.

### One person, several posts

Each post stores the author's ID, name, photo URL, category, text, and creation time. ***authorID*** identifies the person; the post's ***id*** identifies that one message. ***document()*** creates a new ID on each submission instead of using the same user ID. This is similar to adding several message objects to an array in p5.js, where each object can belong to the same person.

### Saving and receiving posts

The new ***addPost*** adapts the class ***updateUser*** pattern: put values in a dictionary and write with ***setData***. The new ***observePostsStart*** adapts the class ***addSnapshotListener*** pattern. It turns documents into a ***posts*** array and uses ***sorted*** to show newer times first. ***ForEach*** displays that array.

The category and text are now separate fields. There is no need to split a combined caption, so a separator inside the message is ordinary text. Names remain visible, and categories display as 🙋, 🤝, or 💬.

### Publishing and errors

***isPosting*** disables repeated taps while the write is pending. The completion callback closes the form after success or displays the error while keeping the input. Empty messages cannot be posted. Refresh removes the old listeners before starting new ones, and signing out removes the listeners and clears the lists.

### Local storage and cloud storage

Week06 saved records in a local JSON file. These posts live in Firestore, so devices using the same lobby can read the same records. The class JSON functions still save lobby settings locally. The old user captions remain in their original documents and are not automatically turned into posts.

## Class Reference and My Changes

The login methods and ***UserModel*** are retained. Dictionary-based saving, ***setData***, snapshot listeners, ***@Environment***, ***ForEach***, and ***AsyncImage*** come from the class example. The new ***lobbyPosts*** path follows the existing ***lobbyUsers*** path.

My changes, with ChatGPT's help, are the independent ***PostModel***, the posts collection, ***addPost***, ***observePostsStart***, and the input form and post rows. The three categories, emoji labels, timestamps, and publishing feedback customize the lobby. These post functions adapt classroom patterns; they are not functions copied unchanged from the teacher's example.

Additional references: [Firebase — Add data](https://firebase.google.com/docs/firestore/manage-data/add-data), [Firebase — Realtime updates](https://firebase.google.com/docs/firestore/query-data/listen).

## Progress and Problems

The updated iOS target compiled successfully. An isolated cloud test verified two separate posts from one author, cross-client reads, all three categories, stored message content, and newest-first timestamp ordering. The temporary test documents and accounts were deleted. A full two-client UI synchronization check of the independent-post version has not been completed.

The class repository rejects forks with HTTP 403 because forking is disabled. The local ***Tiffany*** branch contains the project. Completing the fork submission requires the instructor to enable that setting.

## Final Project Proposal — First Draft

**Working Title: Sound Mood Map**

### Introduction

I want to create an iPhone app that combines environmental sound recordings, a map, and AI to help people record their emotional connections to different places.

We often use photographs to remember a place, but sound can also bring back memories. Subway announcements, conversations on campus, or wind in a park can become connected to how we felt at a particular moment. Users will collect these sounds, add their feelings, and gradually build a personal sound and mood map.

The same place can feel different at different times, and the same sound can mean different things to different people. AI will suggest descriptions of the sound's atmosphere, while users will describe or confirm their own emotions.

The project uses the phone's portability, microphone, and location capabilities so people can make a record while they are experiencing a place.

### Main Features

1. **Record environmental sounds:** Users can record and preview a short sound clip from a street, studio, park, or another everyday setting.
2. **Save the place and time:** Each recording includes its location and time, connecting the sound to a particular moment.
3. **Generate an AI description:** AI will attempt to describe the sound elements and suggest a few atmosphere words and a short sentence. For example: “Wind and distant voices create an open, relaxed atmosphere.” Users can edit the result.
4. **Add personal feelings:** Users can choose mood tags and a color, or write a short note such as “It is noisy here, but I feel less alone.” These feelings come from the user.
5. **Browse and listen on a map:** Each record appears as a map marker. Tapping it opens the recording, time, description, and mood. Users can save several records at the same place to revisit different moments.

For example, someone could record machines and conversations in a school studio and label the moment “busy but comfortable.” Later, listening to that recording could bring back the feeling of being there.

### Implementation Plan

I plan to build the interface with ***SwiftUI***. The main screens will be a map, a recording and editing screen, and a record detail screen.

- **Recording and playback:** I will use the class voice-recorder example as a starting point and Apple's audio tools to save recordings as audio files on the phone. [Audio recording reference](https://developer.apple.com/documentation/avfaudio/avaudiorecorder)
- **Location and map:** I plan to use ***Core Location*** to get the recording location and ***MapKit*** to display the map and record markers. [Map reference](https://developer.apple.com/documentation/mapkit/mapkit-for-swiftui)
- **Local storage:** I will follow the JSON saving approach from class. Each record will store an ID, time, coordinates, mood tags, color, description, and audio filename. Audio files will be saved separately from the JSON data.
- **AI integration:** I will explore an API that supports audio understanding. The app will send a recording and any text the user adds, then receive a description of the sounds and atmosphere. Gemini is one option I plan to test. [Audio understanding reference](https://ai.google.dev/gemini-api/docs/audio)

I will first build the recording, saving, map display, and playback flow. Then I will add AI descriptions and mood editing. The main questions to test are whether the AI descriptions are useful for environmental recordings and how to present the user's own feelings clearly.

The first version will focus on a personal sound map. If time allows, I would like to explore comparing earlier recordings from the same place or letting different users share their sound experiences of a location.

## Weekly Summary

The lobby now keeps multiple posts from each person. I learned the independent-post design by asking ChatGPT, then applied the class Firestore patterns to save and display those posts.
