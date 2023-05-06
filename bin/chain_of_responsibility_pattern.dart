// "Ланцюг відповідальності" в Dart на прикладі сценарію додатку для бронювання:

// У цьому прикладі об'єкт Booking обробляється кожним обробником у ланцюжку
// доти, доки він не буде оброблений обробником або доки не буде досягнутий
// кінець ланцюжка. Якщо обробник може обробити бронювання, він виводить
// повідомлення. В іншому випадку, він передає бронювання наступному обробнику
// в ланцюжку, поки його не обробить або поки не залишиться більше обробників.

// Це дозволяє побудувати гнучку систему, в якій різні типи бронювань можуть
// оброблятися різними обробниками, а порядок їх обробки можна легко змінювати.

// абстрактний клас, який визначає загальні методи, які будуть реалізовувати обробники.

abstract class BookingHandler {
  late BookingHandler _nextHandler;

  set nextHandler(BookingHandler nextHandler) {
    _nextHandler = nextHandler;
  }

  void processBooking(Booking booking);
}

// конкретні обробники, які реалізують інтерфейс BookingHandler і визначають власну поведінку.

class FlightBookingHandler extends BookingHandler {
  @override
  void processBooking(Booking booking) {
    if (booking.bookingType == BookingType.flight) {
      print('Flight booking handled by ${runtimeType.toString()}');
    } else {
      _nextHandler.processBooking(booking);
    }
  }
}

class HotelBookingHandler extends BookingHandler {
  @override
  void processBooking(Booking booking) {
    if (booking.bookingType == BookingType.hotel) {
      print('Hotel booking handled by ${runtimeType.toString()}');
    } else {
      _nextHandler.processBooking(booking);
    }
  }
}

class CarRentalBookingHandler extends BookingHandler {
  @override
  void processBooking(Booking booking) {
    if (booking.bookingType == BookingType.carRental) {
      print('Car rental booking handled by ${runtimeType.toString()}');
    } else {
      _nextHandler.processBooking(booking);
    }
  }
}

// перелік об'єктів, що обробляється обробниками

enum BookingType {
  flight,
  hotel,
  carRental,
}

class Booking {
  final BookingType bookingType;

  Booking(this.bookingType);
}

// Створіть екземпляр кожного обробника і встановіть наступний обробник у ланцюжку.

void main() {
  final flightBookingHandler = FlightBookingHandler();
  final hotelBookingHandler = HotelBookingHandler();
  final carRentalBookingHandler = CarRentalBookingHandler();

// наступний обробник у ланцюжку
  flightBookingHandler.nextHandler = hotelBookingHandler;
  hotelBookingHandler.nextHandler = carRentalBookingHandler;
  carRentalBookingHandler.nextHandler = flightBookingHandler;

  flightBookingHandler.processBooking(Booking(BookingType
      .flight)); // Output: Flight booking handled by FlightBookingHandler
  flightBookingHandler.processBooking(Booking(BookingType
      .hotel)); // Output: Hotel booking handled by HotelBookingHandler
  flightBookingHandler.processBooking(Booking(BookingType
      .carRental)); // Output: Car rental booking handled by CarRentalBookingHandler

  //
  carRentalBookingHandler.processBooking(Booking(BookingType.flight));
  carRentalBookingHandler.processBooking(Booking(BookingType.hotel));
  carRentalBookingHandler.processBooking(Booking(BookingType.carRental));

  //
  hotelBookingHandler.processBooking(Booking(BookingType.carRental));
  hotelBookingHandler.processBooking(Booking(BookingType.flight));
  hotelBookingHandler.processBooking(Booking(BookingType.hotel));
}
