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
3. Check whether user is authenticated
    a. If user is unauthenticated, create a room and join them
    b. if user is authenticated
        i. Check whether these two users are friends
            1. if they are, match them within their existing room_id
            2. else store corressponding details within the chat_room collection and all the messages are posted under messages collection

## Friend Requests
1. Users can send strangers friend requests, these friend requests can only be sent and accepted while the chat is active, if a user leaves chat room before accepting the chat request, the chat will be gone forever.
2. On Accepting the friend request, chat carries on as it is, and the user is saved in friends_list along with room_id

## Closing Room
1. On closing a room, the person who closes the room will go back to home screen
2. The other will stay on chat screen, where they won't be able to message anymore, but can search for a new chat
3. When a user leaves chat screen while their engagement is free, this becomes an indication to delete that specific room from database

## Conditions for closing room
1. When user leaves the chat screen
2. When user closes the app



## Viewing Friends
1. Friends can be seen listed within the friends tab
2. Users can click and continue chatting from where they left off