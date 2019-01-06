// Brunch automatically concatenates all files in your
// watched paths. Those paths can be configured at
// config.paths.watched in "brunch-config.js".
//
// However, those files will only be executed if
// explicitly imported. The only exception are files
// in vendor, which are never wrapped in imports and
// therefore are always executed.

// Import dependencies
//
// If you no longer want to use a dependency, remember
// to also remove its path from "config.paths.watched".
import "phoenix_html"

// Import local files
//
// Local files can be imported directly using relative
// paths "./socket" or full ones "web/static/js/socket".

 import socket from "./socket"

 let channel = socket.channel(`chat_room:lobby`, {});
 let list = $('#message-list');
 let message = $('#msg');
 let username = $('#username');
 let urgency = $('#urgency');
 let channel_list = $('#channel-list');

 channel
 .join()
 .receive('ok', resp => {
     console.log('Joined successfully', resp);
 })
 .receive('error', resp => {
     console.log('Unable to join', resp);
 });

 message.on('keypress', event => {
     if (event.keyCode == 13) {
         channel.push('shout', {
            username: username.val(),
            message: message.val(),
            urgency: urgency.val(),
            chatroom: chatroom,
         });
         message.val('');
     }
 })

//  trigger channel switch
channel_list.on('click', 'li', function(){
    // this should send to channel_view via socket
    channel.push('channel_switch', $(this).text());
})

channel.on('shout', payload => {
     list.append(`<b>${payload.username || 'new_user'}:</b> ${payload.message}<br>`);
     list.prop({
         scrollTop: list.prop('scrollHeight')
     })
 })

channel.on('list_channels', payload => {
    channel_list.append(`<li id="${payload.channel}">${payload.channel}</li>`);
 })

channel.on('clear_frame', event => {
     list.html('')
 })

channel.on('update_active_navbar', payload => {
    // remove all active classes
    $('.active').removeClass('active');
    $(`#${payload.active}`).addClass('active');
 })

channel.on('load_new_channel', payload => {
    chatroom = payload.new;
    channel = socket.channel(`chat_room:${chatroom}`, {})
    channel.join()
      .receive("ok", resp => { console.log("Joined successfully", resp) })
      .receive("error", resp => { console.log("Unable to join", resp) })
 })


$(document).ready(function () {

    $('#sidebarCollapse').on('click', function () {
        $('#sidebar').toggleClass('active');
    });
});

