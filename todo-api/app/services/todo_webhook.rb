# Tells APP_WEBHOOK_URL (when set) that a todo was created. A failure is only
# logged: the todo is saved either way.
class TodoWebhook
  TIMEOUT_SECONDS = 3

  def self.created(todo)
    url = Edgeway.config("APP_WEBHOOK_URL")
    return if url.empty?
    deliver(url, JSON.generate({ "event" => "todo.created", "todo" => todo.as_json }))
  end

  def self.deliver(url, payload)
    response = Edgeway::HTTP.post(url, body: payload, headers: { "Content-Type" => "application/json" }, timeout: TIMEOUT_SECONDS)
    Edgeway.logger.warn("webhook refused", host: host_of(url), status: response.status) unless response.success?
  rescue Edgeway::HTTP::Error => error
    Edgeway.logger.warn("webhook failed", host: host_of(url), error: error.message)
  end

  # Only the host is logged: the path of a webhook URL often holds a secret.
  def self.host_of(url) = url.split("/")[2].to_s
end
