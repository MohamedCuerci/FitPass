// app/javascript/controllers/map_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = {
    markers: Array
  }

  connect() {
    console.log("Map controller connected")
    if (typeof google !== 'undefined' && typeof google.maps !== 'undefined') {
      this.initializeMap();
    } else {
      window.addEventListener('mapsloaded', () => {
        this.initializeMap();
      });
    }
  }

  initializeMap() {
    // Cria o estilo customizado do mapa
    const styledMapType = new google.maps.StyledMapType([
      {
        "featureType": "administrative.land_parcel",
        "elementType": "labels",
        "stylers": [
          {
            "visibility": "off"
          }
        ]
      },
      {
        "featureType": "landscape.natural",
        "elementType": "geometry.stroke",
        "stylers": [
          {
            "visibility": "on"
          }
        ]
      },
      {
        "featureType": "poi",
        "elementType": "labels.text",
        "stylers": [
          {
            "visibility": "off"
          }
        ]
      },
      {
        "featureType": "poi.business",
        "stylers": [
          {
            "visibility": "off"
          }
        ]
      },
      {
        "featureType": "road",
        "elementType": "labels.icon",
        "stylers": [
          {
            "visibility": "off"
          }
        ]
      },
      {
        "featureType": "road.highway",
        "stylers": [
          {
            "color": "#8ba5c1"
          }
        ]
      },
      {
        "featureType": "road.local",
        "elementType": "geometry",
        "stylers": [
          {
            "color": "#c1ccd8"
          }
        ]
      },
      {
        "featureType": "road.local",
        "elementType": "geometry.stroke",
        "stylers": [
          {
            "visibility": "off"
          }
        ]
      },
      {
        "featureType": "transit",
        "stylers": [
          {
            "visibility": "simplified"
          }
        ]
      }
    ], { name: "Styled Map" });


    const mapOptions = {
      center: { lat: -22.7475456, lng: -43.4536448 }, // Centro do Rio de Janeiro
      zoom: 13,
      mapId: "6a9f95caa20671ee",
      disableDefaultUI: true,
      zoomControl: true,
      mapTypeControlOptions: {
        mapTypeIds: ["styled_map"]
      }
    }

    this.map = new google.maps.Map(this.element, mapOptions)

    // Aplica o estilo customizado
    this.map.mapTypes.set("styled_map", styledMapType);
    this.map.setMapTypeId("styled_map")

    // Adiciona os marcadores se existirem
    if (this.hasMarkersValue) {
      this.markersValue.forEach(marker => { 
        // Create a pin element. icone pra aparecer no mapa
        const icon = document.createElement("div");
        icon.innerHTML = '<i class="fa-solid fa-dumbbell fa-rotate-by fa-lg" style="--fa-rotate-angle: 45deg;"></i>';
    
        const pin = new google.maps.marker.PinElement({
          glyph: icon,
          glyphColor: "#ffffff",
          scale: 2,
          background: "#0055DE",
          borderColor: "#ffffff",
        });

        new google.maps.marker.AdvancedMarkerElement({
          position: { lat: marker.lat, lng: marker.lng },
          map: this.map,
          title: marker.name,
          content: pin.element
        })
      })
    }
  }
}



