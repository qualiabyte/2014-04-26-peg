
// INITIALIZER

{
  var _ = options.underscore;

  var merge = function(results) {
    return _.extend.apply(
      null,
      _.flatten([{}, results])
    );
  }
}

start
  = object

// OBJECTS

object
  = proposition
  / argument
  / commit
  / tag

// PROPOSITIONS

proposition
  = "proposition" SP text:propositionText
    { return { object_type: 'proposition', text: text }; }

propositionText
  = $(.*)

// ARGUMENTS

argument
  = header:argumentHeader body:argumentBody
    { return merge([ header, body ]) }

argumentHeader
  = "argument" "\n\n"
    { return { object_type: 'argument' } }

argumentBody
  = title:argumentTitle
    premises:argumentPremiseSha1s
    conclusion:argumentConclusionSha1
    { return merge([ title, premises, conclusion ]) }

argumentTitle
  = "title" SP title:$(nonLF*) LF
    { return { title: title } }

argumentPremiseSha1s
  = sha1s:(argumentPremiseSha1)*
    { return { premise_sha1s: sha1s } }

argumentPremiseSha1
  = "premise" SP sha1:$(nonLF*) LF
    { return sha1 }

argumentConclusionSha1
  = "conclusion" SP sha1:$(nonLF*) LF
    { return { conclusion_sha1: sha1 } }

// COMMITS

commit
  = header:commitHeader body:commitBody
    { return merge([ header, body ]) }

commitHeader
  = "commit\n\n"
    { return { object_type: 'commit' } }

commitBody
  = target:commitTarget
    parents:commitParents
    committer:commitCommitter
    date:commitDate
    host:commitHost
    { return {
        target_type: target.target_type,
        target_sha1: target.target_sha1,
        parent_sha1s: parents,
        committer: committer,
        commit_date: date,
        host: host
       }
     }

commitTarget
  = type:$(nonSP*) SP sha1:$(sha1) LF
    { return { target_type: type, target_sha1: sha1 } }

commitParents
  = parents:(commitParent)*
    { return parents }

commitParent
  = "parent" SP sha1:$(sha1) LF
    { return sha1 }

commitCommitter
  = "committer" SP name:$(nonLF*) LF
    { return name }

commitDate
  = "commit_date" SP date:$(nonLF*) LF
    { return date }

commitHost
  = "host" SP host:$(nonLF*) LF
    { return host }

// TAGS

tag
  = header:tagHeader body:tagBody
    { return merge([ header, body ]) }

tagHeader
  = "tag\n\n"
    { return { object_type: 'tag' } }

tagBody
  = body:( supportBody / disputeBody / citationBody )
    { return body }

supportBody
  = type:tagTypeSupport
    target:tagTarget
    source:tagSource
    { return merge([ type, target, source ]) }

disputeBody
  = type:tagTypeDispute
    target:tagTarget
    source:tagSource
    { return merge([ type, target, source ]) }

citationBody
  = type:tagTypeCitation
    text:tagCitation
    { return merge([ type, text ]) }

tagTypeSupport
  = "tag_type" SP "support" LF
    { return { tag_type: "support" } }

tagTypeDispute
  = "tag_type" SP "dispute" LF
    { return { tag_type: "dispute" } }

tagTypeCitation
  = "tag_type" SP "citation" LF
    { return { tag_type: "citation" } }

tagTarget
  = "target" SP type:$(nonSP*) sha1:$(nonLF*) LF
    { return { target_type: type, target_sha1: sha1 } }

tagSource
  = "source" SP type:$(nonSP*) sha1:$(nonLF*) LF
    { return { source_type: type, source_sha1: sha1 } }

tagCitation
  = "citation_text" SP text:$(.*) LF
    { return { citation_text: text } }

// PRIMITIVES

SP = " "
LF = "\n"
nonLF = [^\n]
nonSP = [^ ]
hex = [0-9a-f]
sha1 = (hex)*
