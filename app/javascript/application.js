import { Application } from "@hotwired/stimulus"
window.Stimulus = Application.start()

Stimulus.handleError = (error, message, detail) => {
  console.warn(message, detail)
  ErrorTrackingSystem.captureException(error)
}
import "./controllers"
