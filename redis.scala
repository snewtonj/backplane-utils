import com.redis._

object RedisHelloWorld {

  def dumpBus(busId: String, r: RedisClient) {
    println(busId)
    var msgIds = r.zrange(busId, 0, -1)
    msgIds match {
      case Some(id) =>  {
        id.foreach(println)
      }
      case None => println("darn")
    }
   
  }
  def scanbus(busIdList: List[Option[String]], r: RedisClient)  {
    println("Buses: " +busIdList)
      busIdList.foreach { busId =>
         busId match {
           case Some(bus) => dumpBus(bus, r)
           case None => println("whoops")
         }
      }
  }
  def main(args: Array[String]) {
    println("Hello, world!")
    val r = new RedisClient("bp-dev", 6379)
    var busindices = r.keys("v1_bus_idx*")
    println(busindices.size + " buses found")
    busindices match {
      case Some(b) => scanbus(b, r)
      case None => println("oopsie")
    }
  }
}
