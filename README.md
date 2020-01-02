# study-java-maven

## com.sample maven project

### 1. setup

```
brew cask install java
brew install maven
```

### 2. create maven project (maven-archetype-webapp)

```
mvn archetype:generate \
  -DarchetypeArtifactId=maven-archetype-webapp \
  -DinteractiveMode=false \
  -DgroupId=com.sample.webapp \
  -DartifactId=hello-world
```

   ```
   [INFO] ----------------------------------------------------------------------------
   [INFO] Using following parameters for creating project from Old (1.x) Archetype: maven-archetype-webapp:1.0
   [INFO] ----------------------------------------------------------------------------
   [INFO] Parameter: basedir, Value: /Users/maehachi08/work/git/java
   [INFO] Parameter: package, Value: com.sample.webapp
   [INFO] Parameter: groupId, Value: com.sample.webapp
   [INFO] Parameter: artifactId, Value: hello-world
   [INFO] Parameter: packageName, Value: com.sample.webapp
   [INFO] Parameter: version, Value: 1.0-SNAPSHOT
   [INFO] project created from Old (1.x) Archetype in dir: /Users/maehachi08/work/git/java/hello-world
   [INFO] ------------------------------------------------------------------------
   [INFO] BUILD SUCCESS
   [INFO] ------------------------------------------------------------------------
   [INFO] Total time:  6.555 s
   [INFO] Finished at: 2019-12-30T09:31:23+09:00
   [INFO] ------------------------------------------------------------------------
   ```

