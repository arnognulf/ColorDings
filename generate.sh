#!/bin/bash
# run this script in a clone of https://github.com/googlefonts/noto-emoji
# verify at: http://www.alanwood.net/demos/wingdings.html

transform ()
{
FROM=${1,,}
TO=${2,,}
for file in $(fdfind ${FROM})
do
cp ${file} ${file/${FROM}/${TO}}
done
sed -i '/^srcs =.*/a\ \ \ \ \"..\/svg\/emoji_u'${TO}'.svg\",' colrv1/all.toml
sed -i '/^srcs =.*/a\ \ \ \ \"..\/svg\/emoji_u'${TO}'.svg\",' colrv1/noflags.toml
}
git checkout colrv1/*.toml
git checkout *.py
git checkout *.tmpl

transform 1f642 004A # "SLIGHTLY SMILING FACE" "J"
transform 1F610 004B # 'NEUTRAL FACE' "K"
transform 1F641 004C # 'SLIGHLTLY FROWNING FACE' "R"
transform 1FA9F 00ff # 'WINDOW' 'Latin Small Letter Y with Diaeresis'

sed -i 's/Noto Color Emoji/ColorDings/g' \
add_emoji_gsub.py \
colrv1/all.toml \
colrv1_generate_configs.py \
colrv1/noflags.toml \
generate_emoji_html.py \
NotoColorEmoji.tmpl.ttx.tmpl

rm -rf venv  # in case you have an old borked venv!
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt
python size_check.py
rm -rf build/ && time make -j $(grep ^processor /proc/cpuinfo|wc -l) BYPASS_SEQUENCE_CHECK='True'

