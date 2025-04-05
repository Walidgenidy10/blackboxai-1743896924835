/**
 * Geolocation Service with Mock Data Fallback
 */
class GeolocationService {
  static getLocation() {
    return new Promise((resolve, reject) => {
      // Mock data for development
      const mockLocation = {
        lat: 40.7128 + (Math.random() * 0.01 - 0.005),
        long: -74.0060 + (Math.random() * 0.01 - 0.005),
        accuracy: 50,
        isMock: true
      };

      if (navigator.geolocation) {
        navigator.geolocation.getCurrentPosition(
          position => resolve({
            lat: position.coords.latitude,
            long: position.coords.longitude,
            accuracy: position.coords.accuracy,
            isMock: false
          }),
          error => {
            console.warn(`Geolocation error (${error.code}): ${error.message}`);
            resolve(mockLocation); // Fallback to mock data
          },
          { enableHighAccuracy: true, timeout: 5000 }
        );
      } else {
        console.warn("Geolocation not supported - using mock data");
        resolve(mockLocation);
      }
    });
  }

  static getLocationStatus(location) {
    return {
      text: `Lat: ${location.lat.toFixed(4)}, Long: ${location.long.toFixed(4)}`,
      icon: location.isMock ? 'info-circle text-blue-500' : 'check-circle text-green-500',
      label: location.isMock ? 'Mock Location' : 'Verified'
    };
  }
}