name := "RedisHelloWorld"

version := "0.0.1"

scalacOptions += "-deprecation"

// XXX: Compile in debug mode, otherwise spring throws exceptions
javacOptions += "-g"

compileOrder := CompileOrder.ScalaThenJava


libraryDependencies ++= Seq(
  // Logging
  "org.slf4j" % "jcl-over-slf4j" % "1.5.10" % "runtime",
  "org.slf4j" % "slf4j-log4j12" % "1.5.10" % "runtime" force(),
  "org.slf4j" % "slf4j-api" % "1.5.10" force(),
  "log4j" % "log4j" % "1.2.16",
  "net.debasishg" % "redisclient_2.9.1" % "2.9"
)

resolvers ++= Seq(
  // For Hibernate Validator
  "JBoss Maven Release Repository" at "https://repository.jboss.org/nexus/content/repositories/releases",
  // Test tools respositories
  "Powermock Repo" at "http://powermock.googlecode.com/svn/repo/",
  "Java.net Repository for Maven" at "http://download.java.net/maven/2/",
  // Coda Hale's Metrics repo
  "repo.codahale.com" at "http://repo.codahale.com",
  // Janrain's dependencies
  "janrain-repo" at "https://repository-janrain.forge.cloudbees.com/release",
  "Spy Repository" at "http://files.couchbase.com/maven2/",
  "codehaus-release" at "http://repository.codehaus.org",
  // For the ehcache dependencies
  "terracotta-releases" at "http://www.terracotta.org/download/reflector/releases",
  // scala-redis
  "typesafe repo" at "http://repo.typesafe.com/typesafe/releases/"
)
