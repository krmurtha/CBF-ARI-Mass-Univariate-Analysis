import flywheel
import os

fw = flywheel.Client() ##API Key is linked secretly to my cubic project directory

project = fw.lookup('bbl/GRMPY_822831') ## This is the project name on flywheel GRMPY
sessions = project.sessions()
subjects = project.subjects()

analysis_str = 'asl' #This is a string that will find the appropriate analysis. Yours is called 'XCP_asl_2020-04-09' so "asl" should work

for sub in subjects:
    """Loop over subjects and get each session"""
    sub_label = sub.label.lstrip('0') #bblid

    for ses in sub.sessions():
        ses_label = ses.label.lstrip('0') #scanids for that bblid
        """Get the analyses for that session"""
        full_ses = fw.get(ses.id)
        these_analyses = [ana for ana in full_ses.analyses if analysis_str in ana.label] # finding analyses results that match our "asl" string
        these_analyses_labs = [ana.label for ana in full_ses.analyses if analysis_str in ana.label]
        if len(these_analyses)<1:
             print('No analyses {} {}'.format(sub_label,ses_label)) #Let us know if we don't find any for this subject
             continue
        for this_ana in these_analyses:
            if not this_ana.files:
                continue

            outputs = [f for f in this_ana.files if f.name.endswith('.zip') #Grab the .zip file of the analysis output
                and not f.name.endswith('.html.zip')]
            output = outputs[0]

            ana_label = this_ana.label.split(' ')[0]

            dest = '/cbica/projects/Kristin_CBF/data/{}/{}/{}/'.format(analysis_str,sub_label,ses_label) ## You need to update this path to be your project folder! I made a dir called "data" in my project folder to put the results in.
            try:
                os.makedirs(dest)
            except OSError:
                print(dest+" exists")
            else: print("creating "+dest)
            dest_file = dest+output.name
            if not os.path.exists(dest_file):
                print("Downloading", dest_file)
                output.download(dest_file)
                print('Done')
