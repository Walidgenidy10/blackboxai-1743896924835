/**
 * Geolocation Service with Enhanced Debugging
 */
class GeolocationService {
  static async getLocation() {
    console.group('[Geolocation] Location Request Started');
    try {
      console.debug('Checking geolocation availability...');
      
      if (!navigator || !navigator.geolocation) {
        console.warn('Geolocation API not available - using mock data');
        return this.getMockLocation();
      }

      console.debug('Requesting geolocation with high accuracy...');
      const position = await new Promise((resolve, reject) => {
        navigator.geolocation.getCurrentPosition(
          resolve,
          reject,
          {
            enableHighAccuracy: true,
            timeout: 10000,
            maximumAge: 0
          }
        );
      });

      console.info('Geolocation successful:', {
        latitude: position.coords.latitude,
        longitude: position.coords.longitude,
        accuracy: position.coords.accuracy + ' meters'
      });

      return {
        lat: position.coords.latitude,
        long: position.coords.longitude,
        accuracy: position.coords.accuracy,
        isMock: false
      };
    } catch (error) {
      console.error('Geolocation failed:', this.getGeolocationError(error));
      console.info('Falling back to mock location data');
      return this.getMockLocation();
    } finally {
      console.groupEnd();
    }
  }

  static getMockLocation() {
    const mock = {
      lat: 40.7128 + (Math.random() * 0.01 - 0.005),
      long: -74.0060 + (Math.random() * 0.01 - 0.005),
      accuracy: 50,
      isMock: true
    };
    console.debug('Generated mock location:', mock);
    return mock;
  }

  static getGeolocationError(error) {
    const errors = {
      1: 'PERMISSION_DENIED',
      2: 'POSITION_UNAVAILABLE',
      3: 'TIMEOUT'
    };
    return {
      code: errors[error.code] || error.code,
      message: error.message
    };
  }

  static getStatusIcon(isMock) {
    return isMock ? 'fa-info-circle text-blue-500' : 'fa-check-circle text-green-500';
  }
}