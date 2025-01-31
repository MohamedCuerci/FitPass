import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  connect() {
    if (navigator.geolocation) {
      navigator.geolocation.getCurrentPosition(
        position => {
          sessionStorage.setItem("latitude", position.coords.latitude);
          sessionStorage.setItem("longitude", position.coords.longitude);
          // this.loadGyms();
          this.updateSession(position.coords.latitude, position.coords.longitude);
        },
        error => {
          console.error("Erro ao obter localização:", error);
          this.handleGeolocationError(error);
        }
      );
    } else {
      console.error("Geolocalização não é suportada pelo navegador.");
    }
  }

  handleGeolocationError(error) {
    if (error.code === 1) {
      alert("Você negou a permissão de localização. Algumas funcionalidades podem não funcionar corretamente.");
    } else if (error.code === 2) {
      alert("Não foi possível determinar sua localização.");
    } else if (error.code === 3) {
      alert("O tempo de resposta para obter a localização expirou.");
    }

    // Define uma localização padrão (exemplo: centro do Rio de Janeiro)
    sessionStorage.setItem("latitude", "-22.9068");
    sessionStorage.setItem("longitude", "-43.1729");

    // this.loadGyms(); // Carrega academias com localização padrão
  }

  updateSession(latitude, longitude) {
    fetch("/store_location", {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]').content
      },
      body: JSON.stringify({ latitude, longitude })
    })
    .then(response => response.json())
    .then(data => console.log("Localização salva na sessão:", data))
    .catch(error => console.error("Erro ao salvar localização:", error));
  }
}
