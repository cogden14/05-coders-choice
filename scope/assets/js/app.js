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

// Source: https://github.com/tensor-programming/phoenix_1.3_chat_app/blob/master/assets/js/app.js

let channel_field = $('channel');
let channel = socket.channel('chat_room:lobby', {});
let list = $('#message-list');
let message = $('#message');
let name = $('#username');
let urgent = $('#urgent');
let peripheral = $('#peripheral');
let urgent_val = "unchecked";
let peripheral_val = "unchecked";
message.on('keypress', event => {
    if (event.keyCode == 13) {
        const channel_name = channel_field.val();

        channel = socket.channel(`chat_room:${channel_name}`, {});
        channel
            .join()
            .receive('ok', resp => {
                console.log('Joined successfully', resp);
            })
            .receive('error', resp => {
                console.log('Unable to join', resp);
            });

        if (urgent.is(":checked"))
        {
          urgent_val = "checked";
        }
        if (peripheral.is(":checked"))
        {
          peripheral_val = "checked";
        }
        channel.push('shout', {
            name: name.val(),
            message: message.val(),
            urgent: urgent_val,
            peripheral: peripheral_val,
            channel_field: channel_field.val(),
        });
        message.val('');
        urgent_val = "unchecked";
        peripheral_val = "unchecked";
    }
});

channel.on('shout', payload => {
    list.append(`${payload.urgent}<b>${payload.name || 'new_user'}:</b> ${payload.message}<br>`);
    list.prop({
        scrollTop: list.prop('scrollHeight')
    });
});

channel
    .join()
    .receive('ok', resp => {
        console.log('Joined successfully', resp);
    })
    .receive('error', resp => {
        console.log('Unable to join', resp);
    });