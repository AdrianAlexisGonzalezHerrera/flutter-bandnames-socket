

class Band {

  String id;
  String name;
  int votes;

  Band({
    required this.id,
    required this.name,
    required this.votes
  });

  // factory Band.fromMap( Map<String, dynamic> obj ) {
  //   return Band();
  // }
  factory Band.fromMap( Map<String, dynamic> obj )
   => Band(
    // id: obj['id'],
    // name: obj['name'],
    // votes: obj['votes']
    id   : obj.containsKey( 'id' )    ? obj['id']    : 'no-id',
    name : obj.containsKey( 'name' )  ? obj['name']  : 'no-name',
    votes: obj.containsKey( 'votes' ) ? obj['votes'] : 'no-votes'
   );
}
