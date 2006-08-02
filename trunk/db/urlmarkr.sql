-- 
-- Table structure for table `bookmarks`
-- 

CREATE TABLE `bookmarks` (
  `id` smallint(5) NOT NULL auto_increment,
  `url` varchar(255) NOT NULL,
  `name` varchar(100) NOT NULL,
  `description` varchar(255) default NULL,
  `created_on` timestamp NOT NULL default CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP,
  `updated_on` timestamp NOT NULL default '0000-00-00 00:00:00',
  `created_by` varchar(255) default NULL,
  `updated_by` varchar(255) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 ;

-- --------------------------------------------------------

-- 
-- Table structure for table `options`
-- 

CREATE TABLE `options` (
  `id` smallint(5) NOT NULL auto_increment,
  `setting` varchar(255) NOT NULL,
  `value` varchar(255) NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 ;

-- --------------------------------------------------------

-- 
-- Table structure for table `preferences`
-- 

CREATE TABLE `preferences` (
  `id` tinyint(5) NOT NULL auto_increment,
  `bookmarks_per_page` tinyint(5) NOT NULL default '10',
  `tags_in_cloud` tinyint(5) NOT NULL default '0',
  `created_by` varchar(255) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 ;

-- --------------------------------------------------------

-- 
-- Table structure for table `tags`
-- 

CREATE TABLE `tags` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(255) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 ;

-- --------------------------------------------------------

-- 
-- Table structure for table `tags_bookmarks`
-- 

CREATE TABLE `tags_bookmarks` (
  `tag_id` int(11) NOT NULL,
  `bookmark_id` int(11) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

-- 
-- Table structure for table `users`
-- 

CREATE TABLE `users` (
  `id` int(10) unsigned NOT NULL auto_increment,
  `login` varchar(80) NOT NULL,
  `salted_password` varchar(40) NOT NULL,
  `email` varchar(60) NOT NULL,
  `firstname` varchar(40) default NULL,
  `lastname` varchar(40) default NULL,
  `salt` char(40) NOT NULL,
  `verified` int(11) default '0',
  `role` varchar(40) default NULL,
  `security_token` char(40) default NULL,
  `token_expiry` datetime default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  `logged_in_at` datetime default NULL,
  `deleted` int(11) default '0',
  `delete_after` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ;
