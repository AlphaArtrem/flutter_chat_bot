/// CallOutcome<T> Class.
///
/// This class holds the two possible outcomes of a function
/// call an `exception` and
/// a successful `data` response to be returned to the calling function.
///
/// The object of CallOutcome can be type casted with <T> make data field
/// strongly coupled to store data of particular type only.
///
/// Both `data` and `exception` cannot be `null` at the same object.
class CallOutcome<T> {
  /// Constructor of the class which accepts three arguments `data`, `exception`
  /// and statusCode
  /// Please it is compulsory to provide at least one of the two argument.
  /// Else an assertion is made resulting in compilation error.
  CallOutcome({required this.statusCode, this.data, this.exception})
      :

        /// Checking if both the member fields are not initialised with null
        assert(
          data != null || exception != null,
          "Both data and exception can't be empty",
        );

  /// `data` member of the class is a general purpose member with datatype
  /// <T> supplied while the creation of the object of class CallOutcome
  /// If non is passed then it can store any value as it happens to
  /// be of `dynamic` type in this case
  final T? data;

  /// `exception` member takes in a value of type `Exception`. If you have your
  /// own exception of string format to be passed it this way to return it:
  ///
  /// `return CallOutcome<String>(exception: Exception(e));`
  ///
  final Exception? exception;

  ///Status code of API call
  final int statusCode;
}
