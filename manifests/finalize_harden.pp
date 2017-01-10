# Runs any tomcat install
class secure_tomcat::finalize_harden {
  $::secure_tomcat::installs.each |$catalina_home, $params| {
    # 2.6 Turn off TRACE
    augeas { 'Turn off TRACE':
      incl    => "${catalina_home}/conf/server.xml",
      lens    => 'Xml.lns',
      context => "/files/${catalina_home}/conf/server.xml/Server",
      changes => [
        'setm Service[*]/Connector[*]/#attribute allowTrace false',
      ],
    }
  }
}
