const message = document.querySelector("#build-message");

if (message) {
  const deployedAt = new Date().toLocaleString(undefined, {
    dateStyle: "medium",
    timeStyle: "short",
  });

  message.textContent = `Latest version loaded: ${deployedAt}`;
}
