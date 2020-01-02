# tomcat manager

## configuration

* [Host Manager App -- HTML Interface](https://tomcat.apache.org/tomcat-9.0-doc/html-host-manager-howto.html)
   1. `${CATALINA_HOME}/conf/tomcat-users.xml`
      * manager-gui role をincludeしたtomcatユーザを記述する

         ```
         <tomcat-users xmlns="http://tomcat.apache.org/xml"
                       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                       xsi:schemaLocation="http://tomcat.apache.org/xml tomcat-users.xsd"
                       version="1.0">
         <!--
           NOTE:  By default, no user is included in the "manager-gui" role required
           to operate the "/manager/html" web application.  If you wish to use this app,
           you must define such a user - the username and password are arbitrary. It is
           strongly recommended that you do NOT use one of the users in the commented out
           section below since they are intended for use with the examples web
           application.
         -->
           <role rolename="tomcat"/>
           <user username="tomcat" password="password" roles="tomcat,manager-gui"/>
         </tomcat-users>
         ```

   2. `${CATALINA_HOME}/conf/server.xml`
      * ユーザをファイル管理する UserDatabaseRealm Realmが有効であること
      * 以下行が有効行であることを確認する

         ```
           <GlobalNamingResources>
             <!-- Editable user database that can also be used by
                  UserDatabaseRealm to authenticate users
             -->
             <Resource name="UserDatabase" auth="Container"
                       type="org.apache.catalina.UserDatabase"
                       description="User database that can be updated and saved"
                       factory="org.apache.catalina.users.MemoryUserDatabaseFactory"
                       pathname="conf/tomcat-users.xml" />
           </GlobalNamingResources>
         ```

   3. `${CATALINA_HOME}/webapps/manager/META-INF/context.xml`
      * tomcat manager appのアクセス許可IPアドレスに必要なIPアドレスを追加する
      * 本設定が適切でない場合は 403 エラーとなる
      * 以下例では docker brdige network(docker0) のnetwork(172.17.0.0/16) に対するアクセス許可を追加している

         ```
            <Valve className="org.apache.catalina.valves.RemoteAddrValve"
         -          allow="127\.\d+\.\d+\.\d+|::1|0:0:0:0:0:0:0:1" />
         +          allow="127\.\d+\.\d+\.\d+|::1|0:0:0:0:0:0:0:1|172\.17\.\d+\.\d+" />
         ```

