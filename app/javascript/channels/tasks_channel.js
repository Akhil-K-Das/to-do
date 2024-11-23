import consumer from "./consumer";

consumer.subscriptions.create("TasksChannel", {
  received(data) {
    console.log("Task update received:", data);
  }
});
