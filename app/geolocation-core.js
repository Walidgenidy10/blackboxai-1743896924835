/**
 * Core Geolocation Service (Minimal Implementation)
 */
class GeolocationService {
  static async getLocation() {
    return new Promise((resolve) => {
      // Basic mock data fallback
      const mockData = {
        lat: 40.7128,
        long: -74.0060,
        accuracy: 50,
        isMock: true
      };

      if (!navigator.geolocation) {
        console.log('Geolocation not available - using mock data');
        return resolve(mockData);
      }

      navigator.geolocation.getCurrentPosition(
        position => resolve({
          lat: position.coords.latitude,
          long: position.coords.longitude,
          accuracy: position.coords.accuracy,
          isMock: false
        }),
        error => {
          console.log('Geolocation error - using mock data:', error.message);
          resolve(mockData);
        }
      );
    });
  }
}