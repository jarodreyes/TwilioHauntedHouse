pusher = new Pusher('46c5ba280c64d8511011')
channel = pusher.subscribe('trick_channel')
channel.bind 'chaos', (data) =>
  document.location = '/chaos/'
