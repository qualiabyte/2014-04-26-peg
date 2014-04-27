var _   = require('lodash');
var fs  = require('fs');
var peg = require('pegjs');

var examples = {
  proposition: "proposition My proposition!"
, argument: "argument\n\n" +
    "title My Argument!\n" +
    "premise b8472d2566fb79e00e391a0bec159bbad0e56a38\n" +
    "premise 75846e5022122e7f67ef711588c7f943c2b5cb2d\n" +
    "conclusion faac5379a6541d0751ce38e6bf2584f10e69efeb\n"
, commit: "commit\n\n" +
    "argument 041d764d8ff4eba66417b0b4e9861a9ef86261d2\n" +
    "parent 9bf85ab5475acab24b42acbb8d860492359e1a46\n" +
    "committer <username>\n" +
    "commit_date <date>\n" +
    "host <hostname>\n"
, tag: "tag\n\n" +
    "tag_type support\n" +
    "target proposition 78bbaaef4453ab0881aa453eca02cdc0c7e1dc7b\n" +
    "source argument cdddaef9bec052758775c4a51d7ed26e6a1b9cb7\n"
};

var grammar = fs.readFileSync('./object-records.pegjs', 'utf8');
var parser = peg.buildParser(grammar);

for (var type in examples) {
  var options = { underscore: _ };
  var record = examples[type];
  var result = parser.parse(record, options);
  console.log(type + ":\n", result);
}
