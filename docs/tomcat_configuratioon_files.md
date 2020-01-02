# tomcat configuration files

* 初期状態

   ```
   ${CATALINA_HOME}/conf/
                      ├ catalina.policy
                      ├ catalina.properties
                      ├ context.xml
                      ├ jaspic-providers.xml
                      ├ jaspic-providers.xsd
                      ├ logging.properties
                      ├ server.xml
                      ├ tomcat-users.xml
                      ├ tomcat-users.xsd
                      ├ web.xml
                      └ Catalina/
                               └ localhost/
   ```


## conf/catalina.policy

* **セキュリティ・マネージャーが管理する Javaに対するセキュリティ制御の設定ファイル**
   * tomcatをSecurity Managerを有効にして起動した場合に参照される
      * `${CATALINA_HOME}/bin/startup.sh -security`
      * `Security Manager`
         * [Apache Tomcat 9 - Security Manager How-To](https://tomcat.apache.org/tomcat-9.0-doc/security-manager-howto.html)
      * `java.security.policy`
         * [Oracle: 3 アクセス権とセキュリティ・ポリシー](https://docs.oracle.com/javase/jp/8/docs/technotes/guides/security/spec/security-spec.doc3.html)
         * [Oracle: Java Development Kit (JDK)でのアクセス権](https://docs.oracle.com/javase/jp/8/docs/technotes/guides/security/permissions.html)
   * デフォルトでは `-security` オプションは付いていない(`catalina.policy` が読み込まれない)

### e.g.

   * `/etc/systemd/system/tomcat.service' の起動コマンドに `-security` オプションを付加
      ```
      bash-4.2# grep ExecStart /etc/systemd/system/tomcat.service
      ExecStart=/opt/apache-tomcat/bin/startup.sh -security
      
      bash-4.2# ps auxfww
      tomcat     440  3.3  5.4 2989584 111172 ?      Sl   07:48   0:06 /usr/bin/java -Djava.util.logging.config.file=/opt/apache-tomcat/conf/logging.properties -Djava.util.logging.manager=org.apache.juli.ClassLoaderLogManager -Djdk.tls.ephemeralDHKeySize=2048 -Djava.protocol.handler.pkgs=org.apache.catalina.webresources -Dorg.apache.catalina.security.SecurityListener.UMASK=0027 -Dignore.endorsed.dirs= -classpath /opt/apache-tomcat/bin/bootstrap.jar:/opt/apache-tomcat/bin/tomcat-juli.jar -Djava.security.manager -Djava.security.policy==/opt/apache-tomcat/conf/catalina.policy -Dcatalina.base=/opt/apache-tomcat -Dcatalina.home=/opt/apache-tomcat -Djava.io.tmpdir=/opt/apache-tomcat/temp org.apache.catalina.startup.Bootstrap start
      ```

## conf/catalina.properties

 * **tomcatのプロパティファイル**
    * `System.setProperty` でセットされる(逆に `System.getProperty` で取得できるのかな)
    * [ここらへんなのかな?](https://github.com/apache/tomcat/blob/3e5ce3108e2684bc25013d9a84a7966a6dcd6e14/java/org/apache/catalina/startup/CatalinaProperties.java#L122-L130)


## conf/context.xml

* **全てのWebアプリケーションについて表す設定ファイル**
   * Webアプリケーションごとの設定
      * `${CATALINA_HOME}/＜conf/server.xml -> `Host の appBase(default: webapps)`＞/アプリケーション名/META-INF/context.xml

## conf/jaspic-providers.xml

* **Java Authentication Service Provider Interface for Containers (JASPIC) 設定ファイル**
   * Webアプリケーションへ認証メカニズムを組み込むためのインターフェースを提供
   * https://tomcat.apache.org/tomcat-8.5-doc/config/jaspic.html

## conf/jaspic-providers.xsd

* **`conf/jaspic-providers.xml` の名前空間を定義したスキーマ文書**

## conf/logging.properties

* **tomcat自身のlogger設定ファイル**
   * https://tomcat.apache.org/tomcat-9.0-doc/logging.html
      * tomcat のSystem.out/err を `${CATALINA_HOME}/logs/catalina.out` へリダイレクトする

## conf/server.xml

* **tomcat自身の設定ファイル**
   * https://tomcat.apache.org/tomcat-9.0-doc/config/index.html

## conf/tomcat-users.xml

* **tomcat host managerの管理者アカウントをファイルで管理するUserDatabase Resourcesの設定ファイル**
   * https://tomcat.apache.org/tomcat-9.0-doc/jndi-resources-howto.html
   * https://tomcat.apache.org/tomcat-8.0-doc/manager-howto.html

## conf/tomcat-users.xsd

* **`conf/tomcat-users.xml` の名前空間を定義したスキーマ文書**

## conf/web.xml

* **全てのWeb servletに適用される設定ファイル**
   * https://tomcat.apache.org/tomcat-9.0-doc/default-servlet.html
   * Webアプリケーションごとの設定
      * `${CATALINA_HOME}/＜conf/server.xml -> `Host の appBase(default: webapps)`＞/アプリケーション名/WEB-INF/web.xml

## conf/Catalina/localhost/

* **Webアプリケーションごとのコンテキストファイルを配置できる**
   * https://tomcat.apache.org/tomcat-8.0-doc/config/context.html#Defining_a_context
   * conf 以下の `Catalina/localhost/` は `＜Engine Name＞/＜Host Name＞` 
      * `${CATALINA_HOME}/conf/server.xml` の以下記述が該当する情報

         ```
         <Engine name="Catalina" defaultHost="localhost">
            <Host name="localhost"  appBase="webapps"
                  unpackWARs="true" autoDeploy="true">
         ```


