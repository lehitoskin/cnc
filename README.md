Command and Control
===================

cnc is the command and control library for sending events to a command process
that takes arbitrary thunks and controls other (sub)processes.

## Structure

```
sub0 (command (sub1 'update)) ->
	command (enqueue (sub1 'update)) ->
sub1 ('update) (received (sub1 'update)) ->
	command (dequeue (sub1 'update))
```

Is this like libevent? Is this completely unnecessary? Who knows!
