# omegle_clone
Omegle Clone is an.. Omegle like app

## Basic Rules
1. Anonymity
2. No real names
3. No profile pictures
4. Only phone number is shared but only to the app, for strict authentication and restrictions

## Searching For Chat
1. Contains search button, on searching engagement status of the user is changed to searching.
2. Two users with searching statuses are picked at random
3. Check whether these two users are friends
    a. if they are match them within their existing room_id
    b. else store corressponding details within the chat_room collection and all the messages are posted under messages collection

## Friend Requests
1. Users can send strangers friend requests, these friend requests can only be sent and accepted while the chat is active, if a user leaves chat room before accepting the chat request, the chat will be gone forever.
2. On Accepting the friend request, chat carries on as it is, and the user is saved in friends_list along with room_id

## Closing Room
1. Upon closing a room, check if the engaged users are friends, if they are, don't delete chats

## Viewing Friends
1. Friends can be seen listed within the friends tab
2. Users can click and continue chatting from where they left off